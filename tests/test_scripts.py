"""Run with: python3 -m unittest discover -s tests."""
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


def write(root, name, text='custom'):
    path = root / name
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text)


class ScriptTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='zoo scripts ')
        self.addCleanup(self.temp.cleanup)
        self.project = Path(self.temp.name) / 'project'
        self.project.mkdir()

    def install(self):
        subprocess.run(['bash', str(ROOT / 'install.sh'), str(self.project)],
                       check=True, capture_output=True, text=True)

    def assert_shared(self):
        claude = self.project / '.claude/skills'
        self.assertTrue(claude.is_symlink())
        self.assertEqual(claude.resolve(), (self.project / '.agents/skills').resolve())
        self.assertTrue((claude / 'zoo/SKILL.md').is_file())

    def test_fresh_install_and_repeat(self):
        self.install()
        self.assert_shared()
        write(self.project, '.agents/skills/zoo-retired/SKILL.md')
        write(self.project, '.claude/agents/zoo-retired.md')
        write(self.project, '.agents/skills/custom/SKILL.md')
        self.install()
        self.assert_shared()
        self.assertFalse((self.project / '.agents/skills/zoo-retired').exists())
        self.assertFalse((self.project / '.claude/agents/zoo-retired.md').exists())
        self.assertEqual((self.project / '.claude/skills/custom/SKILL.md').read_text(), 'custom')

    def test_claude_only_moves_all_skills(self):
        write(self.project, '.claude/skills/custom/SKILL.md')
        write(self.project, '.claude/skills/.hidden', 'hidden')
        self.install()
        self.assert_shared()
        self.assertEqual((self.project / '.agents/skills/custom/SKILL.md').read_text(), 'custom')
        self.assertEqual((self.project / '.agents/skills/.hidden').read_text(), 'hidden')

    def test_agents_only(self):
        write(self.project, '.agents/skills/custom/SKILL.md')
        self.install()
        self.assert_shared()
        self.assertEqual((self.project / '.claude/skills/custom/SKILL.md').read_text(), 'custom')

    def test_identical_trees_merge_before_updating(self):
        for tree in ['.agents', '.claude']:
            write(self.project, tree + '/skills/zoo/SKILL.md', 'old zoo')
            write(self.project, tree + '/skills/custom/SKILL.md')
        self.install()
        self.assert_shared()
        self.assertEqual((self.project / '.agents/skills/custom/SKILL.md').read_text(), 'custom')

    def test_different_trees_stay_separate(self):
        for tree, content in [('.agents', 'agents custom'), ('.claude', 'claude custom')]:
            write(self.project, tree + '/skills/custom/SKILL.md', content)
            write(self.project, tree + '/skills/zoo-retired/SKILL.md')
        self.install()
        self.assertFalse((self.project / '.claude/skills').is_symlink())
        for tree, content in [('.agents', 'agents custom'), ('.claude', 'claude custom')]:
            self.assertEqual((self.project / tree / 'skills/custom/SKILL.md').read_text(), content)
            self.assertEqual((self.project / tree / 'skills/zoo/SKILL.md').read_text(),
                             (ROOT / '.agents/skills/zoo/SKILL.md').read_text())
            self.assertFalse((self.project / tree / 'skills/zoo-retired').exists())

    def test_dangling_standard_link(self):
        (self.project / '.claude').mkdir()
        (self.project / '.claude/skills').symlink_to('../.agents/skills')
        self.install()
        self.assert_shared()

    def test_different_hidden_files_keep_trees_separate(self):
        write(self.project, '.agents/skills/.hidden', 'a')
        write(self.project, '.claude/skills/.hidden', 'b')
        self.install()
        self.assertFalse((self.project / '.claude/skills').is_symlink())
        self.assertEqual((self.project / '.claude/skills/.hidden').read_text(), 'b')

    def test_update_uses_only_shared_skills_for_either_harness(self):
        write(self.project, '.agents/skills/zoo/SKILL.md', 'shared')
        write(self.project, '.agents/skills/custom/SKILL.md', 'do not import')
        write(self.project, '.claude/skills/zoo/SKILL.md', 'wrong source')
        write(self.project, '.claude/agents/zoo-reviewer.md', 'claude agent')
        write(self.project, '.codex/agents/zoo-reviewer.toml', 'codex agent')
        for flags in [('codex',), ('claude',), ('codex', 'claude')]:
            with self.subTest(flags=flags):
                target = Path(self.temp.name) / '-'.join(flags)
                target.mkdir()
                shutil.copy2(ROOT / 'update.sh', target / 'update.sh')
                write(target, '.agents/skills/zoo-retired/SKILL.md')
                write(target, '.agents/skills/retained/SKILL.md')
                subprocess.run(['bash', str(target / 'update.sh'), str(self.project), *flags],
                               check=True, capture_output=True, text=True)
                self.assertEqual((target / '.agents/skills/zoo/SKILL.md').read_text(), 'shared')
                self.assertFalse((target / '.claude/skills').exists())
                self.assertFalse((target / '.agents/skills/zoo-retired').exists())
                self.assertFalse((target / '.agents/skills/custom').exists())
                self.assertTrue((target / '.agents/skills/retained/SKILL.md').exists())
                for harness, filename in [('codex', 'zoo-reviewer.toml'), ('claude', 'zoo-reviewer.md')]:
                    self.assertEqual((target / ('.' + harness) / 'agents' / filename).exists(), harness in flags)

    def test_update_rejects_self_without_removing_skills(self):
        shutil.copy2(ROOT / 'update.sh', self.project / 'update.sh')
        write(self.project, '.agents/skills/zoo/SKILL.md', 'keep')
        result = subprocess.run(['bash', str(self.project / 'update.sh'), str(self.project), 'claude'],
                                capture_output=True, text=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual((self.project / '.agents/skills/zoo/SKILL.md').read_text(), 'keep')

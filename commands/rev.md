Requesting revisions:
$ARGUMENTS

Process:
- If user is requesting code review, call code reviewer before everything else.
- Tech lead agent.
- Test engineer agent is always next. Even if no test changes are planned, let the test engineer confirm that.
- Loop software engineer, test engineer and problem solver agents to execute on each step until done. Manager must step in between every step to reflect the progress and ensure alignment.
- Doc writer agent if relevant (if any changes to public API made, call doc writer).
- Review via code reviewer agent.
- If there are ANY suggestions from code reviewer, go back to test engineer and software engineer to address code reviewer's suggestions. After that, call manager, and then repeat code review. LOOP UNTIL REVIEW FINDS NO SUGGESTIONS.
- HR agent to align the other agents. Use both user's revision instructions and lessons learned from implementing the revisions.
- Finally, librarian agent to store the accumulated knowledge in _ai.

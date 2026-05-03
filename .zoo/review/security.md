Focus on security, privilege escalation, data leaks, phishing and denial of service.

Check for:
- Ability for users to do something beyond their role.
- Fine-grained permissions gating staff (admin) access.
- Access to data without permissions.
- Unsecured URLs that are easy to guess or enumerate.
- Expensive processing or writes that run without any rate limiting and/or security checks.
- Phishing and social engineering attacks on our customers/staff/superadmins by making them follow modified Bubblehouse-related URLs (say, with fraudulent flash messages etc) or doing cross-domain form postbacks.
- Check for other common security issues, but verify against project docs to see if something is deliberately handled elsewhere.
- For a person familiar with the project, the code should be 'obviously secure'; security cannot be an emergent property of a complex set of circumstances, but it IS okay (and desired!) to concentrate say all permission checks in one place as middleware, etc. It's okay to have clear case-by-case overrides for those common checks as well; but everything beyond that, when there's no single specific place + single common place to look in, is too spread out.

Ultrathink!

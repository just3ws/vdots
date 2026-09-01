# Security Policy

This is a personal configuration repository, maintained by one person, best-effort.

## Reporting a vulnerability

Please **do not open a public issue** for security-sensitive reports.

Use GitHub's private vulnerability reporting:
**[Report a vulnerability](https://github.com/just3ws/vdots/security/advisories/new)**
(Security tab → "Report a vulnerability").

Expect an acknowledgement within a week. There is no bug bounty.

## Scope

In scope: anything in this repository that could expose secrets, execute
untrusted code, or weaken the editor it configures — for example a `bin/`
script that mishandles credentials, a workflow that leaks `GITHUB_TOKEN`, or a
default that disables a protection.

Out of scope: third-party tools this repo installs or wraps (report those
upstream), and the security of a machine that has deviated from the documented
setup.

## What this repo already does

- **No secrets committed;** GitHub secret scanning + push protection are on.
- **Least-privilege CI** — workflows declare `permissions: contents: read`.
- **AI workflows are gated** — the Claude review / mention workflows only run
  for the owner, org members, and collaborators, and third-party actions are
  pinned to a commit SHA.
- Plugin lockfile (`vdots-lock.json` or equivalent) is committed and updated
  deliberately via `bin/vdots-update`.

# unfk - Interactive Session Process Killer

**unfk** is a lightweight Perl-based utility for identifying and terminating processes associated with connected terminal sessions.

It is useful when you have a stuck or unresponsive command in a session and cant exit with ctrl+c or ctrl+d, but can open a new shell to manage and kill it safely.

> ⚠️ **Warning:** This tool can terminate running processes. Use with care, especially on shared or production systems.

---

## Features

- Lists active login sessions (`w`)
- Interactive TTY/session selection
- Maps sessions to running processes (`ps`)
- Attempts to match processes by command + session context
- Supports sending signals to processes:
  - `SIGTERM` (graceful shutdown)
  - `SIGKILL` (force kill)
  - `SIGINT` (interrupt)

---

## How it works

1. Reads active sessions using `w`
2. Presents selectable session list by TTY
3. Uses `ps -ef` to enumerate running processes
4. Matches processes against selected session command
5. Allows user to select PID (if multiple matches exist)
6. Sends chosen signal to terminate process

---

## Installation

### Dependencies

#### Required system tools
- `procps-ng`

Check it is working with:
```bash
w -s | head -n 2 | tail -n 1

You should see columns similar to:
USER  TTY  FROM  IDLE  WHAT

If this output is not aligned or missing, this tool will not function correctly.

Perl dependencies
ExtUtils::MakeMaker

On most systems this is available via:

perl-ExtUtils-MakeMaker
or perl-devel


Build & Install
perl Makefile.PL
make
make test
make install

Usage
Run the tool:
unfk


Interactive Flow
1. Select session

Example:

choose a session
----------------
0) TTY: pts/0 | command: bash
1) TTY: pts/1 | command: python script.py
selection:


The tool will:

Attempt to find processes matching the selected session command
Print matching PID(s) and TTY(s)

If multiple matches exist, you will be prompted to choose.

3. Kill process

You will be asked which signal to send:

Options)
1) graceful (SIGTERM)
2) kill (SIGKILL)
3) int (SIGINT)


Project Structure

├── session.pm     # Session discovery and selection
└── unfk.pm        # Process resolution and termination logic

Safety Notes
Process matching is based on command string comparison, double check before you kill stuff.


Recommended usage:

Use from a secondary shell/session
Avoid running blindly on production systems
Double check a few process PID with PS manually and compare against this program before committing to the tool to be sure it lines up as youd expect
Prefer SIGTERM before SIGKILL
Known Limitations
Process matching relies on ps -ef parsing (not fully reliable)

No audit logging
No dry-run mode

Possible Future Improvements
Add --dry-run mode
Add logging/audit trail
Support non-interactive mode for scripting

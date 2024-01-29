lanbash
=======

Unix Bash, Windows Batch and other potential CLI experiments.

TODO
- https://github.com/blueimp/shell-scripts

## Resources

- https://github.com/kevinSuttle/macOS-Defaults
- https://github.com/mathiasbynens/dotfiles
- https://github.com/ohmyzsh/ohmyzsh


## 2024

- https://blog.bytebytego.com/i/127263496/linux-file-system-explained
- https://www.linkedin.com/posts/alexxubyte_systemdesign-coding-interviewtips-activity-7149078423095672833-jvv4/


## [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))

- `#!/bin/sh` – Execute the file using the Bourne shell, or a compatible shell, assumed to be in the /bin directory
- `#!/bin/bash` – Execute the file using the Bash shell
- `#!/usr/bin/pwsh` – Execute the file using PowerShell
- `#!/usr/bin/env` python3 – Execute with a Python interpreter, using the env program search path to find it
- `#!/bin/false` – Do nothing, but return a non-zero exit status, indicating failure. Used to prevent stand-alone execution of a script file intended for execution in a specific context, such as by the . command from sh/bash, source from csh/tcsh, or as a .profile, .cshrc, or .login file.

Notes:

- On my MacOS I have both `/bin/sh` and `/bin/bash`
- But inside of Docker `node:21-alpine` there is only `/bin/sh`, so for Shell scripts like `entrypoint.sh` shebang `#!/bin/sh` matters
- But other Unix/Linux images MAY HAVE different setup!

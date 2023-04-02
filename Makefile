.POSIX:
.FORCE:

help: .FORCE
	@echo "Please use \`$(MAKE) <target>' where <target> is one of"
	@echo '  check             run all checks'
	@echo '  check-manpages    check if a manpage exists for all types'
	@echo '  shellcheck        run shellcheck'

EXPLORERDIR = ./explorer
FILESDIR = ./files
TYPEDIR = ./type


# Checks

check: check-manpages shellcheck

SHELLCHECK = shellcheck
SHELLCHECKCMD = $(SHELLCHECK) -s sh -f gcc -x -a -o require-variable-braces

TYPEFINDOPTS = -type f \( -path '*/explorer/*' -o -name 'manifest' -o -name 'gencode-remote' -o -path '*/files/*.sh' \)

.SILENT: shellcheck
shellcheck: .FORCE
	@command -v $(SHELLCHECK) >/dev/null 2>&1 || { \
		echo 'shellcheck is not installed, cannot check the types.' >&2; \
		exit 1; \
	}
	@{ \
		test -d $(EXPLORERDIR) && find $(EXPLORERDIR) -type f -print; \
		test -d $(TYPEDIR) && find $(TYPEDIR) $(TYPEFINDOPTS) -print; \
		test -d $(FILESDIR) && find $(FILESDIR) -type f -name '*.sh'; \
	} \
	| sed -e "s/'/'\\\\''/g" -e "s/^/'/" -e "s/\$$/'/" \
	| xargs -r -E '' $(SHELLCHECKCMD)

check-manpages: .FORCE
	@{ \
		for t in $(TYPEDIR)/*/; do \
			test -s "$${t%/}/man.rst" || { \
				printf '%s: type has no man page\n' "$${t%/}" >&2; \
				ok=false; \
			}; \
		done; \
		$${ok:-true}; \
	 } && echo 'All types have man pages. Good!'

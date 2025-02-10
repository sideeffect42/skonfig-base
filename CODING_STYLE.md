skonfig-base Shell Coding Style Guidelines
==========================================

This document describes the general coding style guidelines defined for the
skonfig base set. Following the style described below is a requirement for
getting your code integrated into the type set.

**Why?** The maintainers of skonfig are aware that style and taste are something
highly personal and that coding style was and still is a common source of
disagreement among computer scientists. Based on years of experience in Shell
coding and maintaining skonfig we learnt that while having a style guide will
unevitably make some people unhappy, not having one makes everybody unhappy.
The goal of this guide is explicitly *not* to convince anybody that the style
described here is the best of all styles or something. The sole purpose is to
ease the life of maintainers and avoid unnecessary discussions for contributers.


## 1. POSIX shell

The goal of skonfig is to run on every possible system, including your toaster.
For this reason we need a language available on each and every system.  With
decades of work behind it and being implemented in basically all Unix-like
systems this is the POSIX shell language as described by the IEEE 1003.1-2024
standard (aka [POSIX.1-2024]).

1. **All code submitted must be written in POSIX shell.** Usage of other
   programming or scripting languages is not permitted.

2. Usage of language extensions introduced by other shells (e.g. bashisms) is
   not allowed and code making use of such features will be rejected.

3. "Exceptions prove the rule". The usage of shell extensions or other languages
   can be permissible if the following two points are fulfilled:

   1. The language is guaranteed to be available on the target system which
      can run this code.

   2. The job at hand would be impossible or unreasonably complex to solve in
      POSIX shell.

2. No code may produce [ShellCheck] errors.


## 2. 80 columns

1. Files are structured in a way that **lines do not exceed 80 characters**.

2. This is not a hard limit. Lines may exceed 80 characters if there is a reason
   for it, e.g. breaking the line is impossible or would hinder readability.

3. Lines are terminated by LF characters.  
   No Macintosh-style CR or DOS-style CRLF please.


## 3. Indentation and white space

The maintainers of skonfig are well aware that tabs vs space is a very common
source of disagreement among computer scientists, possibly even worse than
Emacs vs vi.

1. For this reason we try to be pragmatic about accepting different styles of
   indentation.

   * a. When creating a new type you are free to pick tabs or how many spaces
        you prefer for indentation.
   * b. When modifying an existing type please be consistent with the style of
        the original author, even if the author has absolutely no taste and
        their choice of indentation is absolutely horrific. :-)

   If you are unsure about which style to pick here are some pros and cons for
   either way.

   * Pro tabs: works in every editor without any configuration. Even the poor
     soul using plain vi(1) can edit tab-indented files without much hassle.
   * Pro tabs: tabs work in combination with indented here documents (`<<-EOF`)
     while a break of indentation style is required for space indented files.
   * Pro tabs: the reader can adjust the separation of code levels as they
     please by changing the tab width in their editor.
   * Pro space: the author can define the layout and the document will look
     exactly the same on every computer (as long as a monospace font is used).
   * Pro space: aligning columns of text is easier.
   * Pro space: is easier to match in POSIX regular expressions than tabs.

2. Restrictions to indentation:

   1. If using spaces for indentation do not use more than 4 spaces per level of
      indentation.
   2. If using tabs for indentation, please use [smart tabs], i.e. use exactly
      one tab character for every level of indentation, followed by spaces for
      alignment.

3. **No trailing white space**

   1. As defined in [POSIX.1-2024 3.387] (with reference to 3.185) every file
      shall be terminated by exactly one LF character.
   2. All other forms of trailing white space are not acceptable, this
      includes, but is not limited to, excessive empty lines at the end of a
      file or *unnecessary* white space characters at the end of a line.

   Please configure your editor to show invisible characters.


## 4. Commands

Commands are the most fundamental parts of a shell script. They consist of
whites space separated arguments where the first argument is special in that it
denotes the program which is run.

1. Command arguments shall be separated by one space character.

2. **Quoting of command arguments.**

   1. Generally fixed string command arguments and options are *not* quoted,
      unless either:

      a. Quoting is necessary to prevent field splitting, tilde expansion,
         pathname (glob) expansion, redirection etc.
         In this case **proper quoting is mandatory**. Not properly quoted
         shell code will be rejected.

      b. Quoting enhances readability.

   2. **Single quotes are preferred** over double quotes. Double quotes shall
      only be used if their usage is required to allow for parameter expansion,
      command substitution etc.

3. **Commands with many arguments shall be split across multiple lines** (using
   the line continuation character `\`) to enhance readability.

   Arguments shall be grouped as lines sensibly.

   **For skonfig objects the following syntax shall be used:**

       ENV1=... \
       ENV2=... \
       require='...' \
       __type name --state state \
           --param1 \
           --param2 foo \
           --source - <<-'EOF'
       content sent to ${__object:?}/stdin
       EOF

   Omitting the parts not needed.
   Multiple parameters may be grouped in a single line if they make sense together, e.g.:

       __file /etc/config-managed \
           --owner 0 --group 0 --mode 0644 \
           --source - <<'EOF'
       This system is configuration managed by skonfig.
       EOF

4. **Omit spacing around input/output redirection operators.**

       # Don't
       echo 'hello world' >> /tmp/myfile.txt

       # Do
       echo 'hello world' >>/tmp/myfile.txt

5. **Prefer here-documents over pipelines.**

   To send some input to a command using a (indented) here-document is
   preferable over a pipeline.


## 5. Comments

1. Comments are introduced by a single `#` character followed by a space.

2. Comments always obey the 80 character limit.
   Longer lines are only acceptable if they are example output of a command used
   to illustrate a point.

3. Comments may use one of these "special" prefixes:

   * "FIXME: "
   * "NOTE: "
   * "TODO: "

   If such a prefix is used, all further lines are indented so that the comment
   lines are aligned.

   Example:

       # just a simple comment

       # NOTE: the following line is special and needs some explanation or there
       #       is some speciality the reader must know about.

       # FIXME: the following code is broken. This type of comment should only
       #        be used in very special circumstances. If code is known to be
       #        broken it should be fixed, not documented.

       # TODO: implement support for operating systems other than Linux.

4. Commented-out code shall not be commited unless there is good reason for it.


## 6. Command lists

1. **One command per line only.** Usage of the semicolon (`;`) to separate
   multiple commands on a single line is strongly discouraged.

   Exception: if having multiple commands on a single line enhances readability,
   its usage is permissible.

2. If multiple commands are combined using the `&&`, `||`, or `|` (pipe)
   operators and their length exceeds 80 characters they shall be split to
   multiple lines with the combination operator as the first on the new line.

   The `&&`, `||`, or `|` operators shall be aligned with the beginning of the
   previous line.

   Example:

       # Don't
       command1 -o one -o two &&
       command2 foo

       # Do
       command1 -o one -o two \
       && command2 foo

   If a compound command follows the combination operator, the compound
   commands's opening character shall be on the same line, e.g.

       command -v special-command >/dev/null 2>&1 || {
           echo 'special-command not found' >&2
           exit 1
       }


## 7. Conditionals and loops

1. The `if` conditional.

   The special keywords `if`/`then`/`elif`/`else`/`fi` shall all be the start of
   their own line and indented to the same level.

   Just like with command lists the usage of the semicolon (`;`) is to be
   avoided.

       # Don't
       if true; then
           :
       elif true; then
           :
       else
           :
       fi

       # Do
       if true
       then
           :
       elif true
       then
           :
       else
           :
       fi

   1. `test` is preferred over `[ ... ]`.

      Especially by people new to shell programming the `[ ... ]` construct gets
      easily misinterpreted as the if parentheses they're used to from other
      programming languages.
      But the square brackets aka `/usr/bin[` are just a regular command which
      behaves like every other command.

      Using `test` instead makes it look like the command execution it actually
      is. And it's just one character longer.

   2. Use the "assert pattern".

      The "assert pattern" (`assumption || error handling`) shall be used to
      check for prerequisites or assumptions with an attached error handler.

      As a rule of thumb: if the block ends in an `exit` or `return` it is
      probably a good case for the "assert pattern".

          # Don't
          if ! test -d /mnt >/dev/null 2>&1
          then
              exit 1
          fi

          # Do
          test -d /mnt || exit 1

2. The `case`.

       case word
       in
           (pattern1)
               compound-list1
               ;;
           (pattern2|pattern3)
               compound-list2
               ;;
           (pattern4)
               statement ;;
        esac

   Note that:

   1. The special keywords `case`/`in`/`esac` shall all be the start of their
      own line and indented to the same level.

   2. The `word` shall not be quoted, because the POSIX shell does no field
   splitting there..

   3. The patterns shall use balanced parentheses.

   4. Use quotes in patterns where necessary.

      The patterns are interpreted as globs by the shell. This includes the
      content of parameter expansions.

      If the pattern contains e.g. white space characters, other glob characters,
      or parameter expansions which shall match literally, use quotes.

   5. Every pattern, including the last one, shall have a terminal `;;`.
      It shall be on its own line and be indented to the level of the
      compound list it's ending.

      If the whole case consists solely of patterns with one statement, the `;;`
      is allowed to be on the same line as the statement.
      Please be consistent and don't mix and match in one `case`.

   Example:

       # Don't
       case "${x}" in
           *) ;;
       esac

       # Do
       case ${x}
       in
           (*) ;;
       esac

3. The `for`, `while`, `until` loops

   The special keywords `for`/`while`/`until`/`do`/`done` shall all be the start
   of their own line and indented to the same level.

   Just like with command lists the usage of the semicolon (`;`) is to be
   avoided.

       # Don't
       for f in ./*; do
           :
       done
       for _arg in "$@"
       do
           :
       done
       while false; do
           :
       done

       # Do
       for f in ./*
       do
           :
       done
       for _arg
       do
           :
       done
       while false
       do
           :
       done


## 8. Variables

1. Variable names are snake_cased and generally lower case.
   Upper case variable names are limited (but not enforced) for constants and
   environment variables.

   Please remain brief when naming variables.

2. Since POSIX does not have a `local` name space, be careful when using
   variables in functions.

   Functions must *never* accidentally override global variables.
   When in doubt consider using a unique variable prefix or a subshell in the
   function.

3. Do not assign and `export`/`readonly` in one step.

   It will *swallow errors* in the assignment.  Moreover, the
   `export`/`readonly` built-in will convert the assignment to behave like a
   command under some circumstances (like parts of the arguments being quoted)
   and suddenly field splitting will be performed again, unlike for all other
   assignments.

   To prevent such "surprises" assigning to a variable and exporting it or
   marking it as readonly shall always be done in two steps.

       # Don't
       export 'foo'=$(echo foo bar; false)  # exit status 0
	   echo "${foo}"                        # foo

       # Do
       foo=$(echo foo bar; false)           # exit status 1
       export foo                           # exit status 0
       echo "${foo}"                        # foo bar

4. Parameter expansions (use of a variable)

   **Parameter expansions always use braces.**

   In addition expansion of skonfig-provided environment variables
   (e.g. `__object`, `__global`, etc.) always use the "indicate error if null or
   unset" operators `${:?}`.

       # Don't
       echo "$x"
       stdin_file="$__object/stdin"

       # Do
       echo "${x}"
       stdin_file="${__object:?}/stdin"

4. Clean up temporarily used variables after yourself (`unset -v`).

   The are very few things more annoying than to debug errors which occur due to
   some old variable left lying around and having a random value triggering
   unexpected behaviour.

   Also, the behaviour of code should never change because of some random state
   of external variables.
   Always initialise variables before use or `unset -v` them before use when in
   doubt.

5. Do not quote command substitutions when assigning to a variable.

   No field splitting is done by the shell when assigning to a variable.
   Quoting will only unnecessarily disable syntax highlighting in most editors.

       # Don't
       myos="$(uname -s)"

       # Do
       myos=$(uname -s)


# 8. Common commands

1. grep

   1. Always use fixed string grep (`grep -F`) when grepping for a literal
      string or a parameter expansion which does not contain a regular
      expression.

   2. Unless you can guarantee that a pattern does not start with a `-` (hyphen)
      add a `-e` option before the pattern to ensure the pattern does not inject
      unwanted options into the grep command.

   3. Do not use ERE grep (`grep -E`) unless required.

      Not all operating systems ship an ERE capable grep by default.


# 9. skonfig type conventions

1. Parameters

   Parameter naming follows common practice.

   1. Names are all lower-case and use the `-` (hyphen) for separating words,
      e.g. `create-home`, `exact-delimiter`, `purge-if-absent`.

   2. Parameters which are marked as `_multiple` use singular names.

   3. Numbers are discouraged to use in a parameter name.

   4. The parameter `--state` is a bit of a special case in skonfig.
      While it is implemented like a regular parameter, its use is so wide
      spread it may seem as if it was a skonfig feature itself.

      Thus, to avoid confusion:

      1. The default value for `--state` is always `present`.

      2. `--state` always accepts the values `present` and `absent`.
         Other, additional, values depending on the type are acceptable.



[POSIX.1-2024]: https://pubs.opengroup.org/onlinepubs/9799919799/
[POSIX.1-2024 3.387]: https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap03.html#tag_03_387
[smart tabs]: https://www.emacswiki.org/emacs/SmartTabs
[ShellCheck]: https://www.shellcheck.net/

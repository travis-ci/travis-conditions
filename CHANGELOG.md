# Changelog

## [Unreleased]

## v1.0.0-dev.1

Major parser rewrite, removing Parslet

### Added
- Variables `os`, `dist`, `group`, `sudo`, `language`, `commit_message`
- Boolean aliases `&&` (alias to `AND`), `||` (alias to `OR`)
- Operator aliases `==` (alias to `=`), `~=` (alias to `=~`)
- Predicates `true`, `false`
- Line continuation using `\`
- Negated `IN` and `IS` operators:
    ```
    NOT branch IN (master, dev) # this worked, and continues to work
    branch NOT IN (master, dev) # this did not work, and now does

    NOT env(foo) IS present # this worked, and continues to work
    env(foo) IS NOT present # this did not work, and now does
    env(foo) IS blank       # btw this is the same
    ```
- Better boolean language parsing of:
    ```
    # evaluate individual terms (no operator)
    true
    false
    env(FOO)

    # compare values
    1 = 1

    # compare function calls
    env(FOO) = env(BAR)

    # compare function calls to variables
    env(FOO) = type

    # nested function calls
    env(env(FOO))

    # function calls in lists
    repo IN (env(ONE), env(OTHER))

    # parenthesis
    (tag =~ ^v) AND (branch = master)
    ```

### Changed
- All values continue to be treated as strings, except `true` and `false`
  which are now treated like Ruby's types.
- Individual terms such as `true` or `env(FOO)` will now evaluate according
  to Ruby's concept of truthiness: everything is true except for `false`
  and absent values.
- Var names and unquoted strings starting with a dollar char `$` now raise
  a parse error. Bash code is not available. Quoted strings still can start
  with a dollar char.

## v0.2.0
### Changed
- Reraise Parselet::ParseFailed as Travis::Conditions::ParseError

## v0.1.0
Initial release

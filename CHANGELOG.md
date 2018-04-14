# Changelog

## [Unreleased]

## v1.0.0-dev.1

Major parser rewrite, removing Parslet

### Added
- Variables `os`, `dist`, `group`, `sudo`, `language`, `commit_message`
- Predicates `true`, `false`
- Operator aliases `==` (alias to `=`), `~=` (alias to `=~`)
- Line continuation using `\`
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

## v0.2.0
### Changed
- Reraise Parselet::ParseFailed as Travis::Conditions::ParseError

## v0.1.0
Initial release

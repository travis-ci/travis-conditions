# Changelog

## [Unreleased]

## v1.0.0-dev.1

Major parser rewrite, removing Parselet

### Added
- Variables `os`, `dist`, `group`, `sudo`, `language`, `commit_message`
- Predicates `true`, `false`
- Operator aliases `==` (alias to `=`), `~=` (alias to `=~`)
- Line continuation using `\`
- Better boolean language parsing of:

    ```
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

## v0.2.0
### Changed
- Reraise Parselet::ParseFailed as Travis::Conditions::ParseError

## v0.1.0
Initial release

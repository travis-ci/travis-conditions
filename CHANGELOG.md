# Changelog

## v1.0.6

### Fixed

- Multiple regular expressions would fail to parse in certain scenarios (see [#12](https://github.com/travis-ci/travis-conditions/pull/12))

### Added

- Add subcommands `parse` and `eval` to `travis-conditions` (previously only supported evaluating conditions, see [docs#1978](https://github.com/travis-ci/docs-travis-ci-com/pull/1978))

## v1.0.5

### Fixed

- Fix normalizing env vars when mixed with secure vars (see [0c5172](https://github.com/travis-ci/travis-conditions/commit/0c517267fd490a7cecd12e4dd484f1c5bfbacba2))

## v1.0.4

### Fixed

- Fix broken error class name

## v1.0.3

### Fixed

- Performance degradation, extract env var parsing to a [separate parser](https://github.com/travis-ci/travis-env_vars).

## v1.0.2

### Fixed

- Multiple env vars given as a single string would not be recognized properly (see [#6](https://github.com/travis-ci/travis-conditions/pull/6))

## v1.0.1

### Added

- Add a `concat` function (see [d7de8b](https://github.com/travis-ci/travis-conditions/commit/d7de8b1dc4f0b17efa9e2caaee43798c782890fa))
- Add a binary `travis-conditions` for testing conditions

## v1.0.0-dev.2

### Added

- Allow evaluating individual values according to Ruby's truethiness (see [ebc500](https://github.com/travis-ci/travis-conditions/commit/ebc50084dacda358607e0f23a898c3ed30e1f4a7))
- Allow `||` and `&&` (aliases to `or` and `and`)
- Introduce a common base error class for both v0 and v1

### Changed

- Disallow strings and variables starting with a `$` (no shell code)

## v1.0.0-dev.1

Major parser rewrite, removing Parslet

### Added
- Variables `os`, `dist`, `group`, `sudo`, `language`, `commit_message`
- Boolean aliases `&&` (alias to `AND`), `||` (alias to `OR`), `!` (alias to `NOT`)
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

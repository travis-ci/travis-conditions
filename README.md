# Boolean language for conditional builds, stages, jobs

## Usage

```ruby
str  = 'branch IN (foo, bar) AND env(baz) =~ ^baz- OR tag IS present'
data = { branch: 'foo', env: { baz: 'baz-1' }, tag: 'v.1.0.0' }
Travis::Conditions.parse(str, data)
# => true
```

## Conditions

Conditions can be specified using a boolean language as follows:

```
(NOT [term] OR [term]) AND [term] OR NOT [term]
```

### Terms

A term is defined as:

```
[left-hand-side] [operator] [right-hand-side]
```

All keywords (such as `AND`, `OR`, `NOT`, `IN`, `IS`, variables, and functions) are case-insensitive.

The left and right hand side part can either be a known variable, a function call, or a value.

#### Variables

Known variables are:

* `type` (the current event type, known event types are: `push`, `pull_request`, `api`, `cron`)
* `repo` (the current repository slug `owner_name/name`)
* `branch` (the current branch name; for pull requests: the base branch name)
* `tag` (the current tag name)
* `sender` (the event sender's login name)
* `fork` (`true` or `false` depending if the repository is a fork)
* `head_repo` (for pull requests: the head repository slug `owner_name/name`)
* `head_branch` (for pull requests: the head repository branch name)

#### Function calls

Known functions are:

* `env(FOO)` (the value of the environment variable `FOO`)

The function `env` currently only supports environment variables that are given in your build configuration (e.g. on `env` or `env.global`), not environment variables specified in your repository settings.

#### Values

Values are strings that are given without quotes, not containing any whitespace or special characters, or single or double quoted strings:

```
"a word"
'a word'
a_word
```

### Operations

#### Equality

This matches a string literally:

```
branch = master
env(foo) = bar
sender != my-bot
```

#### Match

This matches a string using a regular expression:

```
# for simple expressions, not ending in a closing parenthesis:
branch =~ ^master$
env(foo) =~ ^bar$

# if an expression needs to end in a parenthesis wrap it with slashes:
branch =~ /(master|foo)/
```

Usually parenthesis are not required (e.g. the above list of alternatives could also be written as just `master|foo`). If you do need to end a regular expression with a parenthesis then the whole expression needs to be wrapped in `/` slashes.

#### Inclusion

This matches against a list of values:

```
branch IN (master, dev)
env(foo) IN (bar, baz)

branch NOT IN (master, dev)
env(foo) NOT IN (bar, baz)
```

#### Predicates

This requires a value to be present or missing:

```
env(foo) IS present
env(foo) IS NOT present

env(foo) IS blank
env(foo) IS NOT blank
```

This matches against a value's truthyness:

```
fork IS true
fork IS NOT true

fork IS false
fork IS NOT false
```

## EBNF

```
var  = 'type'
     | 'repo'
     | 'head_repo'
     | 'os'
     | 'dist'
     | 'group'
     | 'sudo'
     | 'language'
     | 'sender'
     | 'fork'
     | 'branch'
     | 'head_branch'
     | 'tag'
     | 'commit_message';

func = 'env';
pred = 'present' | 'blank';

eq   = '=' | '==' | '!=';
re   = '=~' | '~=` | '!~';
in   = 'in' | 'not in' | 'IN' | 'NOT IN';
is   = 'is' | 'is not' | 'IS' | 'IS NOT';
or   = 'or' | 'OR';
and  = 'and' | 'AND';

list = oprd | oprd ',' list;
call = func '(' list ')';
val  = word | quoted;

oprd = var | val | call;

term = oprd is pred
     | oprd in '(' list ')'
     | oprd re regx
     | oprd eq oprd
     | oprd;

expr = expr or expr
     | expr and expr
     | not expr
     | '(' expr ')'
     | term
```

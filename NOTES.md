### New variables:

* `os`
* `dist`
* `group`
* `sudo`
* `language`
* `commit_message`

### New predicates:

* `true`
* `false`

It is now possible to use `fork IS true` instead of `fork = true`. These mean
the same, and there's no reason to not use `=`, but we have seen a lot of
people expect these to work.

### New operator aliases:

For the same reason we've added the following operator aliases:

* `==` (alias to `=`)
* `~=` (alias to `=~`)

### Negated `IN` and `IS` operators:

The operators `IN` and `IS` could not be negated the way users expected.
We allowed the following:

```
NOT branch IN (master, dev) # worked, and continues to work
branch NOT IN (master, dev) # did not work, and now does

NOT env(foo) IS present # worked, and continues to work
env(foo) IS NOT present # did not work, and now does
env(foo) IS blank       # (btw this is the same)
```

### Line continuation (multiline conditions):

We were surprised to see users to expect line continuation using `\` to work,
as it does, for example, in Ruby or Python. We liked the idea, so we allowed
this:

```
if: env(PRIOR_VERSION) IS present AND \
    env(PRIOR_VERSION) != env(RELEASE_VERSION) AND \
    branch = master AND \
    type = push
```

Using YAML multiline strings:

```
if: |
  env(PRIOR_VERSION) IS present AND \
  env(PRIOR_VERSION) != env(RELEASE_VERSION) AND \
  branch = master AND \
  type = push
```

### Proper boolean language parsing:

Previously it was not possible to:

* evaluate individual terms (such as `true`)
* compare, say, a value (string) to another, one environment variable (function call) to another, or compare function calls to variables (such as `type` or `branch`).
* nest function calls, or include things other than strings in lists.
* enclose statements in parenthesis the way one would expect in some places (even though not documented).

The following statements now parse and evaluate as expected:

```
# individual terms
true
false

# compare values
1 = 1
true != false

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

### No bash code, please

Variable names and unquoted strings starting with a dollar char `$` now raise a
parse error. Bash code is not available, and these expressions will never evaluate
as the user expects, so it is better to raise an error instead. Quoted strings
still can start with a dollar char.

# Boolean language for conditional builds, stages, jobs (draft)

```
(NOT [term] OR [term]) AND [term]
```

A term can be can be:

#### Equality

```
branch = master
env(foo) = bar
```

#### Match

```
branch =~ ^master$
env(foo) =~ ^bar$
```

#### Include

```
branch IN (master, dev)
env(foo) IN (bar, baz)
```

#### Presence

```
branch IS present
branch IS blank
env(foo) IS present
env(foo) IS blank
```

## Usage

```ruby
str  = 'branch IN (foo, bar) AND env(baz) =~ ^baz- OR tag IS present'
data = { branch: 'foo', env: { baz: 'baz-1' }, tag: 'v.1.0.0' }
Travis::Conditions.apply(str, data)
# => true
```

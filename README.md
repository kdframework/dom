## KDDom

A library focuses to export foundation of the `KDFramework` view tree.

It exports:

- `KDTextNode` A type to represent a single text node that maps to `DOM Text`
- `KDViewNode` A type to represent a single view node that mapx to `DOM Element`

## Motivation

`kdf-dom` provides core functionality for `KDFramework` main component `KDView`.
Defines a `DOM Element` in a way that is applicable to `KDFramework` view layer,
and sets the minimum required functionality to be able to effectively render different
states of view tree.

## Example

```coffee
{ KDViewNode } = require 'kdf-dom'

# represents the following:
# <span class="foo bar">Hello World!</span>
view = new KDViewNode
  tagName  : 'span'
  cssClass : 'foo bar'
  partial  : 'Hello World!'
```

You would almost never want to create a `KDTextNode` with the constructor
but here is how:

```coffee
{ KDTextNode } = require 'kdf-dom'

# represents a `DOM Text` object:
# "Hello World!"
text = new KDTextNode { text: 'Hello World!' }
```

## Installation

```
npm install kdf-dom
```


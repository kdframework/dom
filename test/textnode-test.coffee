jest.autoMockOff()

KDTextNode = require '../src/textnode'

describe 'KDTextNode', ->

  it 'has default options', ->

    node = new KDTextNode

    { value, parent } = node.getOptions()

    expect(value).toBe ''


  it 'has default properties', ->

    node = new KDTextNode

    expect(node.value).toBe ''
    expect(node.nodeType).toBe 'KDTextNode'


  describe 'property accessors', ->

    it 'has accessors for value', ->

      node = new KDTextNode

      node.setValue 'foo'
      expect(node.getValue()).toBe 'foo'

  describe '#destroy', ->

    # FIXME: THIS TEST IS DISGUSTING!
    it 'removes itself from parent', ->

      KDViewNode = require '../src/viewnode.coffee'
      viewNode = new KDViewNode

      viewNode.addSubview node = new KDTextNode
      expect(viewNode.subviews.length).toBe 1

      node.destroy()
      expect(viewNode.subviews.length).toBe 0



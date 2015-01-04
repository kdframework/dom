jest.autoMockOff()

KDViewNode = require '../src/viewnode'
KDTextNode = require '../src/textnode'

describe 'KDViewNode', ->

  it 'has default options', ->

    node = new KDViewNode

    { tagName, domId, cssClass,
      partial, subviews, attributes,
      parent
    } = node.getOptions()

    expect(tagName).toBe 'div'
    expect(cssClass).toBe ''

    expect(domId).toBeNull()
    expect(partial).toBeNull()
    expect(subviews).toEqual []
    expect(attributes).toEqual { style: {} }


  it 'has default properties', ->

    node = new KDViewNode

    expect(node.nodeType).toBe 'KDViewNode'
    expect(node.subviews).toEqual []
    expect(node.id).toBeNull()


  it 'adds a text node if a partial option is passed', ->

    node = new KDViewNode { partial: 'foo' }

    expect(node.subviews[0].value).toBe 'foo'


  it 'gets id from data', ->

    node = new KDViewNode {}, { id: 'foo-123' }

    expect(node.id).toBe 'foo-123'


  describe 'Subview Insertion', ->

    describe '#addSubview', ->

      {node} = {}

      beforeEach -> node = new KDViewNode

      it 'adds subview to subviews array', ->

        prependable = new KDViewNode
        middle      = new KDViewNode
        appendable  = new KDViewNode

        node.addSubview middle
        node.addSubview prependable, yes
        node.addSubview appendable

        expect(node.subviews[0]).toBe prependable
        expect(node.subviews[1]).toBe middle
        expect(node.subviews[2]).toBe appendable

        expect(prependable.parent).toBe node
        expect(middle.parent).toBe node
        expect(appendable.parent).toBe node


      it "doesn't set count if it is lazy", ->

        spyOn node, 'setSubviewCount'

        # Third argument is `lazy`
        node.addSubview new KDViewNode, no, yes

        expect(node.setSubviewCount.calls.length).toEqual 0

        # Third argument is `lazy`
        node.addSubview new KDViewNode, no, no

        expect(node.setSubviewCount.calls.length).toEqual 1


    describe '#addSubviews', ->

      {node} = {}

      beforeEach -> node = new KDViewNode

      it 'adds subviews', ->

        first  = new KDViewNode
        second = new KDViewNode
        third  = new KDViewNode

        node.addSubviews [first, second, third]

        expect(node.subviews[0]).toBe first
        expect(node.subviews[1]).toBe second
        expect(node.subviews[2]).toBe third


      it 'only updates subview count once', ->

        spyOn node, 'setSubviewCount'

        first  = new KDViewNode
        second = new KDViewNode
        third  = new KDViewNode

        node.addSubviews [first, second, third]

        # it's 1, not 3
        expect(node.setSubviewCount.calls.length).toEqual 1


  describe '#destroySubviews', ->

    it 'cleans up subviews', ->

      node = new KDViewNode {subviews: [new KDViewNode, new KDViewNode]}

      expect(node.subviews.length).toBe 2

      node.destroySubviews()

      expect(node.subviews.length).toBe 0


  describe '#destroy', ->

    it 'destroys itself along with subviews', ->

      node  = new KDViewNode
      child = new KDViewNode

      node.addSubview parent
      expect(node.subviews.length).toBe 1

      child.destroy()

      expect(node.subviews.length).toBe 1


  describe '#addPartial', ->

    it 'adds text node to subviews', ->

      node = new KDViewNode

      node.addPartial 'foo'
      expect(node.subviews[0].value).toBe 'foo'

      node.addPartial new KDTextNode { value: 'bar' }
      expect(node.subviews[1].value).toBe 'bar'


    it 'prepends text node', ->

      node = new KDViewNode

      node.addPartial 'foo'
      node.addPartial 'bar', yes

      expect(node.subviews[0].value).toBe 'bar'


  describe '#updatePartial', ->

    it 'clears everything inside and adds partial', ->

      node = new KDViewNode
        subviews: [ new KDViewNode, new KDViewNode ]

      node.updatePartial 'foo'
      expect(node.subviews.length).toBe 1
      expect(node.subviews[0].value).toBe 'foo'

      node.updatePartial 'bar'
      expect(node.subviews.length).toBe 1
      expect(node.subviews[0].value).toBe 'bar'



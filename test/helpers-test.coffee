jest.dontMock '../src/helpers.coffee'

helpers = require '../src/helpers.coffee'

describe 'helpers', ->

  describe '.isViewNode', ->

    { isViewNode } = helpers

    it 'checks if given is a view node', ->

      textNode = { value: 'foo', nodeType: 'KDTextNode' }

      expect(isViewNode textNode).toBe no
      expect(isViewNode null).toBe no
      expect(isViewNode undefined).toBe no

      viewNode = { value: 'foo', nodeType: 'KDViewNode' }

      expect(isViewNode viewNode).toBe yes


  describe '.isTextNode', ->

    { isTextNode } = helpers

    it 'checks if given is a text node', ->

      viewNode = { value: 'foo', nodeType: 'KDViewNode' }

      expect(isTextNode viewNode).toBe no
      expect(isTextNode null).toBe no
      expect(isTextNode undefined).toBe no

      textNode = { value: 'foo', nodeType: 'KDTextNode' }

      expect(isTextNode textNode).toBe yes


  describe '.getAttributes', ->

    { getAttributes } = helpers

    it 'returns attributes with dom id and css class', ->

      node =
        options:
          domId      : 'qux'
          cssClass   : 'foo bar'
          attributes : { src: 'kd.io' }

      attrs = getAttributes node

      expect(attrs.id).toBe 'qux'
      expect(attrs.className).toBe 'foo bar'
      expect(attrs.src).toBe 'kd.io'



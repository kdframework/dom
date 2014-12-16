{ KDObject } = require 'kdf-core'

module.exports = class KDTextNode extends KDObject

  ###*
   * @constructor KDTextNode
   *
   * @param {Object=}     options
   * @param {String=}     options.value - The text value of node.
  ###
  constructor: (options = {}) ->

    options.value  or= ''

    super options

    @value  = options.value

    @define 'text', => @value


  ###*
   * Instead of `instanceof` check we are using
   * `nodeType` property of prototype.
  ###
  nodeType: 'KDTextNode'


  ###*
   * Sets the value of node.
   *
   * @param {String} value
  ###
  setValue: (value) -> @value = value

  ###*
   * Returns the value of node.
   *
   * @return {String} value
  ###
  getValue: -> @value

  ###*
   * Destroy text node instance itself.
   * Removes itself from parent's `subviews` Array if
   * `@parent` is present.
  ###
  destroy: ->

    return  unless @parent

    index = @parent.subviews.indexOf this
    @parent.subviews.splice index, 1



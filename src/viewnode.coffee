{ KDObject } = require 'kdf-core'

KDTextNode     = require './textnode'
{ isViewNode } = require './helpers'

module.exports = class KDViewNode extends KDObject

  ###*
   * @constructor KDViewNode
   *
   * @param {Object} options - View options.
   * @param {String=} options.tagName - HTML tag of DOM element.
   * @param {String=} options.cssClass - HTML css class name of DOM element.
   * @param {String=} options.domId - HTML element id of DOM element.
   * @param {String=} options.partial - Text content of DOM element.
   * @param {Array.<KDViewNode|KDTextNode>=} options.subview - initial subviews for this view.
   * @param {Object=} options.attributes - Text content of DOM element.
   * @param {Object=} options.attributes.style - Text content of DOM element.
   *
   * @param {Object=} data
  ###
  constructor: (options = {}, data = {}) ->

    options.tagName    or= 'div'
    options.cssClass   or= ''
    options.domId      or= null
    options.partial    or= null
    options.subviews   or= []
    options.attributes or= {}
    options.attributes.style or= {}

    super options, data

    @subviews = options.subviews

    @updatePartial options.partial  if options.partial

    @id = options.id or data.id or null

    # needs to be extracted to a mixin.
    @setSubviewCount()

    # Support for `vdom/patch`.
    # It requires a children property, so
    # define an attribute that returns subviews.
    @define 'children', => @subviews


  ###*
   * Instead of `instanceof` check we are using
   * `nodeType` property of prototype.
  ###
  nodeType: 'KDViewNode'


  ###*
   * To be able to performantly traverse the dom tree and mapping them to
   * view nodes, we are setting children count with the view instance.
   * The idea is borrowed from VNode#constructor `vtree/vnode`.
   *
   * @return {integer} count - ViewNode subviews count.
   * @see {@link `vtree/vnode`} for more info.
  ###
  setSubviewCount: ->

    count = @subviews.length

    descendants = 0

    for subview in @subviews when isViewNode subview

      descendants += subview.count or 0

    @count = count + descendants


  ###*
   * Adds a subview to view node. It assigns this node
   * to it's subviews' parent.
   *
   * @param {KDViewNode|KDTextNode} subview - Subview to be added.
   * @param {Boolean=} prepend - Flag for prepending or appending.
   * @param {Boolean=} lazy - Flag for setting subview count after adding finishes.
  ###
  addSubview: (subview, prepend = no, lazy = no) ->

    if prepend
    then @subviews.unshift subview
    else @subviews.push subview

    subview.parent = this

    @setSubviewCount()  unless lazy


  ###*
   * Adds multiple subviews to view node.
   *
   * @param {Array.<KDViewNode|KDTextNode} subviews
  ###
  addSubviews: (subviews) ->

    @addSubview subview  for subview in subviews


  ###*
   * Walks trough all of the subviews and calls
   * `destroy` on them.
   *
   * @return {Array} subviews - empty subviews list.
  ###
  destroySubviews: ->

    @subviews = subview.destroy()  for subview in @subviews

    @subviews = []


  ###*
   * Destroy view instance itself with its subviews.
   * Removes itself from parent's `subviews` Array if
   * `@parent` is present.
  ###
  destroy: ->

    @destroySubviews()

    return  unless @parent

    index = @parent.subviews.indexOf this
    @parent.subviews.splice index, 1


  ###*
   * Adds a text node into `subviews` array.
   *
   * @param {KDTextNode|String} partial - Either a string value or `KDTextNode` instance.
   * @param {Boolean} prepend - Flag for prepending or appending.
   * @see KDViewNode#addSubview
  ###
  addPartial: (partial, prepend = no) ->

    partial = new KDTextNode { value: partial }  if 'string' is typeof partial
    @addSubview partial, prepend


  ###*
   * A method to determine if this view needs to be rerendered.
   * `KDDomDiff` will call this method when it's diffing.
   *
   * @param {KDViewNode|KDTextNode} next - Next state of the view.
   * @return {Boolean} shouldUpdate
  ###
  shouldUpdate: (next) -> yes


  ###*
   * Removes all subviews and adds a new partial to the view.
   *
   * @param {KDTextNode|String} partial
   * @see KDViewNode#destroySubviews
   * @see KDViewNode#addPartial
  ###
  updatePartial: (partial) ->

    @destroySubviews()
    @addPartial partial



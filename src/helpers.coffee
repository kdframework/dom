###*
 * @param {*}
 * @return {Boolean}
###
isViewNode = (x) -> x?.nodeType in ['KDViewNode']


###*
 * @param {*}
 * @return {Boolean}
###
isTextNode = (x) -> x?.nodeType is 'KDTextNode'

###*
 * Attaches necessary options to attributes
 * object, so that relevant diffing operations
 * can work properly.
 *
 * @param {KDViewNode} node - View node instance to be extracted.
###
getAttributes = (node) ->

  attrs           = node.options.attributes or {}
  attrs.id        = node.options.domId
  attrs.className = node.options.cssClass

  return attrs

module.exports = {
  isViewNode
  isTextNode
  getAttributes
}

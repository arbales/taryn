$('body').tubular('kU2qaF0p_EQ','wrapper')
#

createCircle = (item) ->
  _.defaults item,
    type: "editing"
  circlePath = ["/assets", item.type, "circle-#{item.name}.png"].join('/')
  """
  <li><img src="#{circlePath}" /></li>
  """

fetchEditing = ->
  $.getJSON '/assets/editing.json', (data) ->
    _.each data, (item) ->
      circle = createCircle(item)
      $('.pane-editing ul').append circle
    $('.pane-editing').show()

class TarynRouter extends Backbone.Router
  routes:
    ""         : "index"
    "about"    : "index"
    "editing"  : "editing"

  index: ->
    $('.pane-editing ul').addClass('animate-out')
  editing: ->
    fetchEditing()

router = new TarynRouter()
Backbone.history.start({pushState: true})

$(document).on 'click', 'a', (e) ->
  e.preventDefault()
  a = $(e.target)
  fragment = Backbone.history.getFragment(a.attr('href'))
  router.navigate fragment, true

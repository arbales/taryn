BackgroundVideo =
  mute: ->
    callPlayer($('#myytplayer'), "mute")
  unmute: ->
    callPlayer($('#myytplayer'), "unMute")
  pause: ->
    callPlayer($('#myytplayer'), "pauseVideo")
  play: ->
    callPlayer($('#myytplayer'), "playVideo")

flashCheck = ->
  $('html').addClass(if typeof swfobject isnt 'undefined' && swfobject.getFlashPlayerVersion().major isnt 0  then 'flash' else 'no-flash')
  if $('html').hasClass 'flash'
    $('body').tubular 'kU2qaF0p_EQ','wrapper',
      playButtonClass: 'tubular-play'
      pauseButtonClass: 'tubular-pause'
      muteButtonClass: 'tubular-mute'
  else
    window.callPlayer = ->

flashCheck()
###
jQuery.fn.slider = ->
BV = new $.BigVideo()
BV.init();
BV.show('http://camero.417east.com/taryn/wave.m4v',{ambient:true, loop: true})
###

Array::collect = Array::map

createCircle = (item) ->
  _.defaults item,
    type: "editing"
  circlePath = ["/assets", item.type, "#{item.name}-circle.png"].join('/')
  """
  <li><img src="#{circlePath}" /></li>
  """


window.T = Ember.Application.create()

T.Router.map ->
  @route 'editing'
  @route 'directing'
  @route 'about'
  # @route 'contact'
  @resource 'project', {path: '/projects/:name'}


# T.GalleryController = Ember.ArrayController.extend
Project = Ember.Object.extend
  className: ( ->
    "circle-size-#{@get('size')}"
  ).property('size')

  isEditing: (->
    @get('type') is "editing"
  ).property('type')
  circlePath: (->
    "/assets/#{@get('type')}/#{@get('name')}-circle.png"
  ).property 'name', 'type'

  posterPath: (->
    "/assets/#{@get('type')}/#{@get('name')}-poster.png"
  ).property 'name', 'type'

  id: (-> @get('name')).property('name')

T.Projects = window.Projects.collect (project) ->
  Project.create project

T.ProjectRoute = Ember.Route.extend
  model: (params) ->
    T.Projects.findProperty 'name', params.name

T.ProjectController = Ember.ObjectController.extend
  currentVideoNo: 0
  currentVideoId: ( ->
    @content.get('vimeo')[@get('currentVideoNo')]
  ).property('currentVideoNo', 'content.name')
  currentVideoURL: ( ->
    "http://player.vimeo.com/video/#{@content.get('vimeo')[@get('currentVideoNo')]}?title=0&amp;byline=0&amp;portrait=0&amp;autoplay=1"
  ).property('currentVideoNo', 'content.name')

  shouldPaginate: (->
    @content.get('vimeo').length > 1
  ).property('content.vimeo')

  paginationSlug: (->
    "#{@get('currentVideoNo')+1} of #{@content.get('vimeo').length}"
  ).property('currentVideoNo')

  pickVideo: (videoId) ->
    @set 'currentVideoNo', @content.get('vimeo').indexOf(videoId)



T.ProjectView = Ember.View.extend
  toggleActivePage: (->
    unless @get('element')
      @set 'element', @findElementInParentElement()
    if @get('element')
      @$('.pagination').removeClass('active').addClass (index, current) =>
        if index is @controller.get('currentVideoNo')
          "active"
        else
          ""
  ).observes('controller.currentVideoNo')

  resize: =>
    top = ($(window).height() - @$('.viewer').outerHeight())/2.5
    if $(window).height() < @$('.viewer').outerHeight()
      top = 0
    @$('.viewer').css
      marginTop: top

  didInsertElement: ->
    Ember.run.next BackgroundVideo.pause
    @toggleActivePage()
    @resize()
    Ember.run.next @resize
    $(window).on 'resize', @resize

    $('html').toggleClass 'viewer-frame', on
    $('#yt-container').css
      opacity: 0

  willDestroyElement: ->
    BackgroundVideo.play()
    $('html').toggleClass 'viewer-frame', off
    $('#yt-container').css
      opacity: 0.5

T.NavigatorView = Ember.View.extend
  isExpanded: no
  toggle: (state = !@isExpanded) ->
    @$('.navbar-vertical').toggle state
    @isExpanded = state
  click: (e) ->
    unless $(e.target).hasClass 'navigator'
      @toggle(off)

T.AboutView = Ember.View.extend
  classNames: ["about"]
  resize: =>
    top = ($(window).height() - @$('.about').outerHeight())/2
    if $(window).height() < @$('.about').outerHeight()
      top = 0
    @$('.about').css
      marginTop: top
  didInsertElement: ->
    Ember.run.next @resize

    $(window).on 'resize', @resize
  willDestroyElement: ->
    $(window).off 'resize', @resize


T.DirectingView = Ember.View.extend
  templateName: "gallery"
  resize: =>
    top = ($(window).height() - @$('.pane-editing').outerHeight())/2.5
    if $(window).height() < @$('.pane-editing').outerHeight()
      top = 0
    @$('.pane-editing').css
      position:'absolute'
      top: top
  didInsertElement: ->
    Ember.run.next @resize

    $(window).on 'resize', @resize
  willDestroyElement: ->
    $(window).off 'resize', @resize


T.EditingView = T.DirectingView.extend()
    
T.DirectingRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set 'projects', T.Projects.filterProperty('type', 'directing')

  exit: ->
    $('.panes').fadeOut()

T.EditingRoute = Ember.Route.extend
  setupController: (controller) ->
    controller.set 'projects', T.Projects.filterProperty('type', 'editing')


  exit: ->
    $('.panes').fadeOut()


Ember.Handlebars.registerBoundHelper 'vimeoEmbed', (url) ->
  v = new Handlebars.SafeString """<div><iframe src="#{url}" width="854" height="480" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe></div>"""

Ember.Handlebars.registerBoundHelper 'breakLines', (text) ->
  # text = Handlebars.Utils.escapeExpression text
  new Handlebars.SafeString text.replace(/\n/g,"<br>")

T.initialize()








###
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
###

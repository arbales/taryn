kVerticallyCenterClassName = '.__shouldVerticallyCenter'
kPositionIdeallyClassName = '.__shouldPositionIdeally'

positionIdeally = (el) ->
  w = $(window)
  el = $(el)
  offset = (w.height() - el.height()) / 3
  offset = if offset > 220 then 220 else offset
  offset = if offset < 160 then 160 else offset

  el.css
    marginTop: "#{offset}px"
  el.trigger 'position:changed'

verticallyCenter = (el, position = 'absolute', callback = jQuery.noop) ->
  w = $(window)
  el = $(el)
  
  if el.hasClass '__static'
    position = '__static'

  styles = 
    position: position
  if position is 'absolute'
    _.extend styles,
      top:      "#{(w.height() - el.height()) / 2.5}px"
      left:     "#{(w.width() - el.width()) / 2}px"
  else
    _.extend styles,
      marginTop: "#{(w.height() - el.height()) / 2.5}px"

  el.css styles

  el.trigger 'position:changed'
  el.toggleClass kVerticallyCenterClassName, on
  callback(el)

$(window).resize _.throttle ->
  $(kPositionIdeallyClassName).each (index, el) ->
    positionIdeally el
, 50

$(kPositionIdeallyClassName).each (index, el) ->
    positionIdeally el

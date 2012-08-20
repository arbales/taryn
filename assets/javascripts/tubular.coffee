width       = 853
ratio       = 16 / 9
defaultDiv  = 'wrapper'

resizePlayer = ->

jQ = jQuery

jQ.fn.tubular = (video, wrapperId) ->
  wrapperId = wrapperId ? 'wrapper'
  timeout = setTimeout resizePlayer, 1000
  jQ('html,body').css 'height', '100%'
  jQ('body').prepend '''
  <div data-role="youtube-container" style="overflow:hidden; position: fixed; z-index: 1;">
    <div data-role="youtube-api-player">
      Video on this site requires Flash Player 8 and Javascript.
    </div>
  </div>
  <div data-role="video-cover" style="position: fixed; width:100%; height: 100%; z-index: 2;" />
  '''
  
  jQ("##{wrapperId}").css
    position: 'relative'
    zIndex:   99
  
  youtubePlayer   = 0
  pageWidth       = 0
  pageHeight      = 0
  videoHeight     = videoWidth / videoRatio
  duration        = 0

  iframe = """
  <iframe id="
  """

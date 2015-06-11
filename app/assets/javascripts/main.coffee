# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.Cartograph = {}

window.Cartograph.createMap = ->
  return if Cartograph.map != undefined
  container = $('#map-canvas')[0]
  mapOptions =
    center:
      lat: 49.7015539175044
      lng: -126.10991385853303
    zoom: 7



  Cartograph.map = new google.maps.Map(container, mapOptions);

jQuery.fn.highlight = ->
  $(this).each ->
    el = $(this)
    el.before("<div/>")
    el.prev().width(el.width()).height(el.height()).css({
        "position": "absolute",
        "background-color": "#ffff99",
        "opacity": ".9"
      })
    .fadeOut(500)
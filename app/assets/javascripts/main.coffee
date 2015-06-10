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
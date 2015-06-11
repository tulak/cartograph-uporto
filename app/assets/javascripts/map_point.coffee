class Cartograph.MapPoint
  constructor: (id, title, lat, lng) ->
    @id = id
    @title = title
    @lat = lat
    @lng = lng
    @latLng = new google.maps.LatLng(@lat, @lng)

  pos: ->
    { lat: @lat, lng: @lng}

  show: ->
    @render().setVisible(true)

  hide: ->
    @render().setVisible(false)

  destroy: ->
    @marker.setMap(null)

  render: ->
    @marker ||= new google.maps.Marker
      position: @pos()
      map: Cartograph.map
      title: @title
class Cartograph.MapPoint
  constructor: (id, title, lat, lng) ->
    @id = id
    @title = title
    @lat = lat
    @lng = lng
#    @id, @title, @lat, @lng = id, title, lat, lng

  pos: ->
    { lat: @lat, lng: @lng}

  show: ->
    @render().setVisible(true)

  hide: ->
    @render().setVisible(false)

  render: ->
    @marker ||= new google.maps.Marker
      position: @pos()
      map: Cartograph.map
      title: @title
      animation: google.maps.Animation.DROP,
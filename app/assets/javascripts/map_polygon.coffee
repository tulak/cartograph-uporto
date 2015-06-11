class Cartograph.MapPolygon
  constructor: (id, title, polygons_data, party) ->
    @id = id
    @title = title
    @polygons_data = $(polygons_data)
    @party = party
    @polygons = $([])

  show: ->
    @render()
    @polygons.each (_, p) -> p.setVisible(true)

  hide: ->
    @render()
    @polygons.each (_, p) -> p.setVisible(false)

  focus: ->
    bounds = new google.maps.LatLngBounds()
    @polygons.each (_, polygon) ->
      $(polygon.getPaths().getArray()).each (_, path) ->
        $(path.getArray()).each (_, point) -> bounds.extend(point)

    Cartograph.map.fitBounds(bounds)

  color: () ->
    if @party
      switch @party
        when "green" then '#00FF00'
        when "liberal" then '#0000FF'
        when "unity" then '#FFE90D'
        when "ndp" then '#C1001B'
    else
      '#FF0000'

  render: ->
    return if @polygons.length > 0
    @polygons_data.each (_, polygon) =>
      paths = polygon.map (line) ->
        line.map (point) -> new google.maps.LatLng(point[0], point[1])

      polygon = new google.maps.Polygon
        paths: paths
        strokeColor: @color()
        strokeOpacity: 0.8
        strokeWeight: 2
        fillColor: @color()
        fillOpacity: 0.35

      infowindow = new google.maps.InfoWindow
        content: @title

      google.maps.event.addListener polygon, 'click', (event)->
        infowindow.open(Cartograph.map)
        infowindow.setPosition(event.latLng)

      @polygons.push polygon


    @polygons.each (_, p) -> p.setMap(Cartograph.map)
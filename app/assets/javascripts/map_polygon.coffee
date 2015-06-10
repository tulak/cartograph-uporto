class Cartograph.MapPolygon
  constructor: (id, title, polygons_data) ->
    @id = id
    @title = title
    @polygons_data = $(polygons_data)
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

  render: ->
    return unless @polygons.empty()
    @polygons_data.each (_, polygon) =>
      paths = polygon.map (line) ->
        line.map (point) -> new google.maps.LatLng(point[0], point[1])

      polygon = new google.maps.Polygon
        paths: paths
        strokeColor: '#00FF00'
        strokeOpacity: 0.8
        strokeWeight: 2
        fillColor: '#00FF00'
        fillOpacity: 0.35

      infowindow = new google.maps.InfoWindow
        content: @title

      google.maps.event.addListener polygon, 'click', (event)->
        infowindow.open(Cartograph.map)
        infowindow.setPosition(event.latLng)

      @polygons.push polygon


    @polygons.each (_, p) -> p.setMap(Cartograph.map)
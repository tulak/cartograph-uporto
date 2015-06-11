class Cartograph.MapPoints
  constructor: (links) ->
    @links = links
    @objects = {}
    Cartograph.createMap()
    @links.each (index, link) =>
      $(link).change => @render($(link))

  bounds: ->
    bounds = new google.maps.LatLngBounds()
    $.each @objects, (_, o) ->
      bounds.extend(o.latLng)
    bounds

  renderAll: ->
    @links.each (_, link) => @render($(link))

  showAll: =>
    @links.each (_, link) =>
      link = $(link)
      object = @objects[link.attr("id")]
      object.show()
      link.attr("checked", true)

  hideAll: =>
    @links.each (_, link) =>
      link = $(link)
      object = @objects[link.attr("id")]
      object.hide()
      link.attr("checked", false)


  destroy: ->
    $.each @objects, (_, object) ->
      object.destroy()

  render: (link)=>
    object = @objects[link.attr("id")]
    if object == undefined
      object = new Cartograph.MapPoint(link.attr("id"), link.data("title"), link.data("lat"), link.data("lng"))
      @objects[object.id] = object

    if link[0].checked
      object.show()
      Cartograph.map.setCenter(object.pos())
      Cartograph.map.setZoom(12)
    else
      object.hide()




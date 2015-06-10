class Cartograph.Pubs
  constructor: (links) ->
    @links = links
    @objects = {}
    Cartograph.createMap()
    @links.each (index, link) =>
      $(link).change => @render($(link))

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




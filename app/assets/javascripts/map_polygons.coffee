class Cartograph.MapPolygons
  constructor: (links) ->
    @links = links
    @objects = {}
    Cartograph.createMap()
    @links.each (index, link) =>
      $(link).change => @render($(link))

  render: (link)=>
    object = @objects[link.attr("id")]
    if object == undefined
      object = new Cartograph.MapPolygon(link.attr("id"), link.data("title"), link.data("polygons"))
      @objects[object.id] = object

    if link[0].checked
      object.show()
      object.focus()
    else
      object.hide()




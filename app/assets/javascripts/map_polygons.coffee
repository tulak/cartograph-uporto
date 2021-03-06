class Cartograph.MapPolygons
  constructor: (links) ->
    @links = links
    @objects = {}
    Cartograph.createMap()
    @links.each (index, link) =>
      $(link).change => @render($(link))

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

  render: (link)=>
    object = @objects[link.attr("id")]
    if object == undefined
      object = new Cartograph.MapPolygon(link.attr("id"), link.data("title"), link.data("polygons"), link.data("party"))
      @objects[object.id] = object

    if link[0].checked
      object.show()
      object.focus()
    else
      object.hide()




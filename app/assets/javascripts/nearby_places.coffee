class Cartograph.NearbyPlaces
  constructor: (form, results_container) ->
    @form = form
    @results_container = results_container

    @registerEvents()

  registerEvents: () ->
    $(@form).find(".choose-point").click @startChoosing
    $(@form).on "ajax:success", @renderPoints

  startChoosing: =>
    Cartograph.map.setOptions({ draggableCursor: 'crosshair' })
    google.maps.event.addListenerOnce(Cartograph.map, 'click', @choosePoint)

  choosePoint: (e) =>
    @clear()
    Cartograph.map.setOptions({ draggableCursor: 'pointer' })
    $(@form).find("[data-name=lat]").prop("value", e.latLng.lat())
    $(@form).find("[data-name=lng]").prop("value", e.latLng.lng())

    @current_marker?.setMap(null)
    @current_marker = null
    @current_marker ||= new google.maps.Marker
      position: { lat: e.latLng.lat(), lng: e.latLng.lng() }
      map: Cartograph.map
      title: "Selected place"
      animation: google.maps.Animation.DROP
      icon: "http://maps.google.com/mapfiles/ms/icons/blue-dot.png"

    @form.submit()

  renderPoints: (event, response) =>
    $(response).each (_, r) => @renderRecord(r)
    @mapPoints = new Cartograph.MapPoints(@results_container.find(".nearby-place"))
    @mapPoints.renderAll()
    @mapPoints.showAll()
    bounds = @mapPoints.bounds()
    if bounds.isEmpty()
      @results_container.text("No records found")
      @results_container.highlight()
    else
      bounds.extend(@current_marker.getPosition())
      Cartograph.map.fitBounds(bounds)

  clear: =>
    @mapPoints?.hideAll()
    @mapPoints?.destroy()
    @results_container.empty()

  renderRecord: (r) =>
    el = {}
    el.p = $("<p></p>")
    el.input = $("<input>").attr
      id: "nearby_place_" + r.id
      class: "nearby-place cursor-pointer"
      type: "checkbox"
      'data-lat': r.point.lat
      'data-lng': r.point.lng
    el.label = $("<label></label>").text(r.title).attr
      for: "nearby_place_" + r.id

    el.p.append(el.input)
    el.p.append(" ")
    el.p.append(el.label)

    @results_container.append(el.p)

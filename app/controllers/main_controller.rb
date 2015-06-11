class MainController < ApplicationController
  layout "map"

  def pubs
    @pubs = BCPub.select("*, ST_TRANSFORM(geom, 4326) AS ggeom").order("name ASC")
  end

  def hospitals
    @hospitals = BCHospital.select("*, ST_TRANSFORM(geom, 4326) AS ggeom").order("name ASC")
  end

  def municipalities
    @pubs = BCPub.select("*, ST_TRANSFORM(geom, 4326) AS ggeom").order("name ASC")
    @municipalities = BCMunicipality.select("*, ST_TRANSFORM(geom, 4326) AS ggeom").order("name ASC")
    @polygons = {}

    @municipalities.each do |mun|
      @polygons[mun.id] = mun.ggeom.collect do |pol|
        if pol.boundary.is_a? RGeo::Geos::CAPILineStringImpl
          [pol.boundary.points.collect { |p| [p.y, p.x] }]
        else
          pol.boundary.collect do |ls|
            ls.points.collect { |p| [p.y, p.x] }
          end
        end
      end
    end

  end

  def nearby_places
    @nearby_places = NearbyPlaces.new(params[:nearby_places])

    @records = @nearby_places.find_places

    respond_to do |format|
      format.html
      format.json { render json: @records.to_json }
    end
  end

  def political_map
    @regions = BCVotingArea.select("SUM(ndp) AS ndp_sum,
                                    SUM(liberal) AS liberal_sum,
                                    SUM(green) AS green_sum,
                                    SUM(unity) AS unity_sum,
                                    riding AS region,
                                    ST_TRANSFORM(ST_BOUNDARY(ST_UNION(geom)), 4326) AS ggeom
                                    ").group("riding").order("riding ASC")
    @parties = {}

    @regions.each do |r|
      h = { ndp: r.ndp_sum, liberal: r.liberal_sum, green: r.green_sum, unity: r.unity_sum }
      @parties[r.region.parameterize] = h.key(h.values.max)
    end

    @polygons = {}

    # binding.pry

    @regions.each do |mun|
      case mun.ggeom
      when RGeo::Geos::CAPILineStringImpl
        @polygons[mun.region.parameterize] = [[mun.ggeom.points.collect { |p| [p.y, p.x] }]]
      when RGeo::Geos::CAPIMultiLineStringImpl
        @polygons[mun.region.parameterize] = mun.ggeom.collect do |ls|
          [ls.points.collect { |p| [p.y, p.x] }]
        end
      else
        puts "Bas class #{mun.ggeom.class}"
      end
    end
  end

end

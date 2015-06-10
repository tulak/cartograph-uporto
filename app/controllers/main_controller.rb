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
end

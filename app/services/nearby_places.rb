class NearbyPlaces
  GOOGLE_SRID = 4326

  DEFAULTS = {
      record_name: :pub,
      distance: 5,
      lat: 0,
      lng: 0
  }

  include ActiveModel::Model
  attr_accessor :record_name, :distance, :lat, :lng

  def initialize *attrs
    super
    DEFAULTS.each do |k,v|
      self.send("#{k}=", v) if self.send(k).blank?
    end
  end

  def find_places
    where_clause = <<-SQL
      ST_DISTANCE(
        ST_TRANSFORM(geom, #{GOOGLE_SRID}),
        ST_GeomFromText('POINT(#{lng} #{lat})', #{GOOGLE_SRID}),
        true
      ) <= #{distance_metres}
    SQL
    record_model.select("*, ST_TRANSFORM(geom, #{GOOGLE_SRID}) AS ggeom").where(where_clause).collect do |r|
      Record.new(id: r.id, title: r.name, geom: r.ggeom)
    end
  end

  def distance_metres
    distance.to_d * 1000
  end

  def record_model
    @model ||= case record_name.to_sym
               when :hospital then
                 BCHospital
               when :pub then
                 BCPub
               else
                 raise AgumentError, "model_name"
               end
  end

  class Record
    attr_accessor :id, :title, :geom
    include ActiveModel::Model

    def point
      { lat: geom.y, lng: geom.x }
    end

    def to_hash
      {
          id: id,
          title: title,
          point: point
      }
    end
  end
end
class Track < ActiveRecord::Base
    require 'rubygems'
    require 'nokogiri'
    
    before_save :parse_file
    attr_accessible :name, :gpx
    has_many :tracksegments, :dependent => :destroy
    has_many :points, :through => :tracksegments
    
    has_attached_file :gpx
    
    def parse_file
        tempfile = gpx.queued_for_write[:original]
        doc = Nokogiri::XML(tempfile)
        doc.remove_namespaces!
        points = doc.xpath('//trkpt')
        point = Array.new
        points.each do |trkpt|
            lat = trkpt.xpath('@lat')
            lon = trkpt.xpath('@lon')
            name = trkpt.xpath('//name').text.to_s
            ele = trkpt.xpath('//ele').text.to_s
            desc = trkpt.xpath('//desc').text.to_s
            point_created_at = trkpt.xpath('//time').text.to_s
            point << {latitude: lat, longitude: lon, name: name, elevation: ele, description: desc, 
                      point_created_at: point_created_at}
        end
    end
    
    
        
end

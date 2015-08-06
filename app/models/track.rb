class Track < ActiveRecord::Base
    require 'rubygems'
    require 'nokogiri'
    
    before_save :parse_file
    attr_accessible :name, :gpx
    has_many :tracksegments, :dependent => :destroy
    has_many :points, :through => :tracksegments
    
    has_attached_file :gpx,
                      :path => "ParseUploadXML/public/paperclip/:filename"
    
    def parse_file
        tempfile = gpx.queued_for_write[:original]
        doc = Nokogiri::XML(tempfile)
        trackpoints = doc.xpath('//trkpt')
        points = Array.new
        trackpoints.each do |trkpt|
            lat = trkpt.xpath('@lat')
            lon = trkpt.xpath('@lon')
            name = trkpt.xpath('/name').to_s
            ele = trkpt.xpath('/ele').to_s
            desc = trkpt.xpath('/desc').to_s
            point_created_at = trkpt.xpath('/time').to_s
            points << {latitude: lat, longitude: lon, name: name, elevation: ele, description: desc, 
                      point_created_at: point_created_at}
        end
        points
    end
    
    
        
end

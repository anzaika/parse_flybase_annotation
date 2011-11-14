require_relative "parse_flybase_annotation/version"
require 'ostruct'

module ParseFlybaseAnnotation
  class Mrna < OpenStruct; end
  class Segment < OpenStruct; end

  def self.parse( filepath )
    annotation = File.open(filepath, 'r').readlines
    annotations.map do |ant|
      ant_split = ant.split("\t")
  end

  def self.parse_annotation_string( string )
    splitted = string.split("\t")
    OpenStruct.new(
      {
        'chromosome' => ant_split[2],
        'strand'     => ant_split[3],
        'mrna_id'    => ant_split[7]
      }
    )
  end

end

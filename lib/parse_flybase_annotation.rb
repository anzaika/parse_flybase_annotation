require_relative "parse_flybase_annotation/version"
require 'set'
require 'ostruct'

module ParseFlybaseAnnotation
  class Mrna < OpenStruct; end
  class Exon < OpenStruct; end

  def self.parse( filepath )
    mrnas = []
    exons = []

    File.open(filepath, 'r')
        .each_line{|line| mrnas << self.parse_annotation_string(line) }

    mrnas.map{|mrna| mrna.gene_id}.uniq.each do |gene_id|
      exons <<
        self.generate_exons_from(mrnas.find_all{|mrna| mrna.gene_id == gene_id})
    end

    {'mrnas' => mrnas, 'exons' => exons.flatten}
  end

  def self.parse_annotation_string( string )
    splt = string.split
    Mrna.new(
      {
        'mrna_id'    => splt[1],
        'gene_id'    => parse_gene_id(splt[1]),
        'chromosome' => parse_chromosome_name(splt[2]),
        'strand'     => splt[3],
        'exons'      => self.parse_exons(splt[9], splt[10], splt[6], splt[7])
      })
  end

  def self.parse_gene_id( mrna_id )
    mrna_id.scan(/\d+/).first
  end

  def self.parse_chromosome_name( chromosome )
    case chromosome
    when 'chrXhet', 'chrYhet' then nil
    when 'chr2L','chr2R','chr3R','chr3L','chrX' then
      chromosome[3,2]
    else
      warn "Can't parse chromosome name -> #{chromosome}"
      nil
    end
  end

  def self.parse_exons( start_coord, stop_coord, mrna_c_start, mrna_c_stop )
    exons =
      start_coord
        .split(',')
        .map{|el| el.to_i}
        .zip( stop_coord
                .split(',')
                .map{|el| el.to_i}
            )
    exons[0][0] = mrna_c_start.to_i
    exons[-1][-1] = mrna_c_stop.to_i

    exons
  rescue => e
    warn "Error when parsing exons: #{start_coord}|#{stop_coord}"
    raise
  end

  def self.generate_exons_from( mrnas )

    exons =
      mrnas
        .map{|mrna| mrna.exons}
        .flatten(1)
        .uniq
        .map{|exon| Exon.new({'start'=>exon.first, 'stop'=>exon.last, 'mrnas'=>[]})}

    exons.each do |exon|
      mrnas.each do |mrna|
        if mrna.exons.include?([exon.start, exon.stop])
          exon.mrnas << mrna.mrna_id
        end
      end
    end

    mrna_ids = mrnas.map{|mrna| mrna.mrna_id }
    exons.each do |exon|
      mrna_ids.all?{|mrna_id| exon.mrnas.include?(mrna_id)} ? spl = 'const' : spl = 'alt'
      exon.splicing = spl
      exon.chromosome = mrnas.first.chromosome
    end

    exons
  end

end

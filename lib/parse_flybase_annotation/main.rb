require_relative 'db'

module ParseFlybaseAnnotation

  def self.parse_and_upload( filepath )
    ParseFlybaseAnnotation::DB
      .new('hpc09', 'dmel_annotation')
      .upload_annotation(self.parse(filepath))
  end

  # code here needs heavy refactoring
  def self.parse( filepath )
    mrnas = []
    exons = []

    File.open(filepath, 'r')
        .each_line do |ann_string|
          mrna = self.generate_mrnas_from(ann_string)
          mrnas << mrna if mrna.chromosome
        end

    mrnas.map(:gene_id).uniq.each do |gene_id|
      exons <<
        self.generate_exons_from(
          mrnas.find_all{|mrna| mrna.gene_id == gene_id }
        )
    end

    {'mrnas' => mrnas, 'exons' => exons.flatten}
  end

  # Generate Mrna object from annotation string
  # @param [String] ann_string annotation string
  # @return [Mrna]
  def self.generate_mrnas_from( ann_string )
    splt = ann_string.split
    Mrna.new(
      {
        'mrna_id'    => splt[1],
        'gene_id'    => generate_gene_id_from(splt[1]),
        'chromosome' => parse_chromosome_name(splt[2]),
        'strand'     => splt[3],
        'exons'      => self.parse_exons(splt[9], splt[10], splt[6], splt[7])
      })
  end

  # Extract gene_id from mrna_id
  # @param [String] mrna_id
  # @return [String]
  def self.generate_gene_id_from( mrna_id )
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

  # Parse exon start&stop coordinates
  #
  # @example
  #   ParseFlybaseAnnotation.parse_exons('1,5,10,', '4,9,15', '2', '3')
  #
  # @param [String] start_coord comma separated list of start coordinates
  # @param [String] stop_coord comma separated list of stop coordinates
  # @param [String] mrna_c_start a string with integer denoting the start
  #   of coding part of mrna
  # @param [String] mrna_c_stop a string with integer denoting the stop
  #   of coding part of mrna
  # @return [Array]
  def self.parse_exons( start_coord, stop_coord, mrna_c_start, mrna_c_stop )
    exons =
      start_coord
        .split(',')
        .map(:to_i)
        .zip( stop_coord
                .split(',')
                .map(:to_i)
            )
    exons[0][0] = mrna_c_start.to_i
    exons[-1][-1] = mrna_c_stop.to_i

    # this step implements the 5' shift that is
    # noted in parse_gene_annotation.feature
    exons.each{|e| e[0]+=1}

  rescue => e
    warn "Error when parsing exons: #{start_coord}|#{stop_coord}|#{mrna_c_start}|#{mrna_c_stop}"
    raise
  end

  def self.generate_exons_from( mrnas )

    exons =
      mrnas
        .map(:exons)
        .flatten(1)
        .uniq
        .map{|exon| Exon.new({'start'=>exon.first, 'stop'=>exon.last, 'mrnas'=>[]}) }

    exons.each do |exon|
      mrnas.each do |mrna|
        if mrna.exons.include?([exon.start, exon.stop])
          exon.mrnas << mrna.mrna_id
        end
      end
    end

    mrna_ids = mrnas.map(:mrna_id)
    exons.each do |exon|
      mrna_ids.all?{|mrna_id| exon.mrnas.include?(mrna_id)} ? spl = 'const' : spl = 'alt'
      exon.splicing = spl
      exon.chromosome = mrnas.first.chromosome
    end

    exons
  end

end

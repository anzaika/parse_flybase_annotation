require 'spec_helper'
require 'set'

module ParseFlybaseAnnotation
describe "ParseFlybaseAnnotation" do

  let(:mrna_1) {
    ParseFlybaseAnnotation::Mrna.new(
      {
        'mrna_id'    => 'CG11023-RA',
        'gene_id'    => '11023',
        'chromosome' => '2L',
        'strand'     => '+',
        'exons'   => [[7680,8116],[8229,8589],[8668,9276]]
      })
  }

  let(:mrna_2) {
    ParseFlybaseAnnotation::Mrna.new(
      {
        'mrna_id'    => 'CG11023-RB',
        'gene_id'    => '11023',
        'chromosome' => '2L',
        'strand'     => '+',
        'exons'   => [[7680,8116],[8668,9276]]
      })
  }

  let(:exons_1) {
    [
      Exon.new({ 'start' => 7680,
                 'stop' => 8116,
                 'chromosome' => '2L',
                 'mrnas' => ['CG11023-RA'],
                 'splicing' => 'const'}),

      Exon.new({ 'start' => 8229,
                 'stop' => 8589,
                 'chromosome' => '2L',
                 'mrnas' => ['CG11023-RA'],
                 'splicing' => 'const'}),

      Exon.new({ 'start' => 8668,
                 'stop' => 9276,
                 'chromosome' => '2L',
                 'mrnas' => ['CG11023-RA'],
                 'splicing' => 'const'}),
    ]}

  let(:exons_2) {
    [
      Exon.new({ 'start' => 7680,
                 'stop' => 8116,
                 'chromosome' => '2L',
                 'mrnas' => ['CG11023-RA', 'CG11023-RB'],
                 'splicing' => 'const'}),

      Exon.new({ 'start' => 8229,
                 'stop' => 8589,
                 'chromosome' => '2L',
                 'mrnas' => ['CG11023-RA'],
                 'splicing' => 'alt'}),

      Exon.new({ 'start' => 8668,
                 'stop' => 9276,
                 'chromosome' => '2L',
                 'mrnas' => ['CG11023-RA','CG11023-RB'],
                 'splicing' => 'const'}),
    ]}

describe "::generate_mrnas_from" do
  it "should parse a string with tabbed columns into correct Mrna object" do
    annotation_string =
      "585     CG11023-RA      chr2L   +       7528    9491    7679    9276    3       7528,8228,8667, 8116,8589,9491,"
    ParseFlybaseAnnotation
      .generate_mrnas_from(annotation_string)
      .should == mrna_1
  end
end

describe "::generate_gene_id_from" do
  it "should parse gene_id out of mrna_id: CG11023-RA -> 11023" do
    ParseFlybaseAnnotation.generate_gene_id_from("CG11023-RA").should == '11023'
  end
end

describe "::parse_chromosome_name" do
  it "should parse 'chr(2L|2R|3R|3L|X)' into '(2L|2R|3R|3L|X)' respectively" do
    ParseFlybaseAnnotation.parse_chromosome_name('chr2L').should == '2L'
    ParseFlybaseAnnotation.parse_chromosome_name('chr2R').should == '2R'
    ParseFlybaseAnnotation.parse_chromosome_name('chr3R').should == '3R'
    ParseFlybaseAnnotation.parse_chromosome_name('chr3L').should == '3L'
    ParseFlybaseAnnotation.parse_chromosome_name('chrX').should  == 'X'
  end
  it "should parse 'chrXhet' and 'chrYhet' into nil" do
    ParseFlybaseAnnotation.parse_chromosome_name('chrXhet').should  be_nil
    ParseFlybaseAnnotation.parse_chromosome_name('chrYhet').should  be_nil
  end
  it "should return nil for unknown input" do
    ParseFlybaseAnnotation.parse_chromosome_name('chr2X').should  be_nil
    ParseFlybaseAnnotation.parse_chromosome_name('chr0X').should  be_nil
    ParseFlybaseAnnotation.parse_chromosome_name('0X').should  be_nil
    ParseFlybaseAnnotation.parse_chromosome_name('chr').should  be_nil
  end
end

describe "::parse_exons" do
  it "should parse segmens start and stop coordinates cutting the UTRs" do
    ParseFlybaseAnnotation
      .parse_exons('1,5,10,', '4,9,15,', '2', '13')
      .should == [[3,4],[6,9],[11,13]]
  end
end

describe "::generate_exons_from" do
  it "should correctly generate exons from an array with one mrna" do
    ParseFlybaseAnnotation
      .generate_exons_from([mrna_1])
      .should == exons_1
  end
  it "should correctly generate exons from an array with multiple mrnas" do
    ParseFlybaseAnnotation
      .generate_exons_from([mrna_1,mrna_2])
      .should == exons_2
  end
end

end
end

require 'spec_helper'

module ParseFlybaseAnnotation
describe "ParseFlybaseAnnotation" do

  let(:mrna) {
    ParseFlybaseAnnotation::Mrna.new(
      {
        'mrna_id'    => 'CG11023-RA',
        'gene_id'    => 11023,
        'chromosome' => '2L',
        'strand'     => '+',
        'segments'   => [[7679,8116],[8228,8589],[8667,9276]]
      })
  }
  let(:segments) {
    [
      Segment.new({'start' => 1,
                   'stop' => 2,
                   'chromosome' => '2L',
                   'mrnas' => ['CG11023-RA'],
                   'splicing' => 'const'}),
      Segment.new({'start' => 3,
                   'stop' => 4,
                   'chromosome' => '2L',
                   'mrnas' => ['CG11023-RA'],
                   'splicing' => 'alt'}),
      Segment.new({'start' => 5,
                   'stop' => 6,
                   'chromosome' => '2L',
                   'mrnas' => ['CG11023-RA'],
                   'splicing' => 'alt'}),
    ]
  }

describe "::parse_annotation_string" do
  it "should parse a string with tabbed columns into correct Mrna object" do
    annotation_string =
      "585     CG11023-RA      chr2L   +       7528    9491    7679    9276    3       7528,8228,8667, 8116,8589,9491,"
    ParseFlybaseAnnotation
      .parse_annotation_string(annotation_string)
      .should == mrna
  end
end

describe "::parse_gene_id" do
  it "should parse gen'})d out of mrna_id: CG11023-RA -> 11023" do
    ParseFlybaseAnnotation.parse_gene_id("CG11023-RA").should == 11023
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

describe "::parse_segments" do
  it "should parse segmens start and stop coordinates cutting the UTRs" do
    ParseFlybaseAnnotation
      .parse_segments('1,5,10,', '3,8,12,', '2', '11')
      .should == [[2,3],[5,8],[10,11]]
  end
end

describe "::infer_splicing" do
  it "should infer splicing from an array of mrnas" do
    ParseFlybaseAnnotation
      .infer_splicing(mrna)
      .should == segments
  end
end

end
end

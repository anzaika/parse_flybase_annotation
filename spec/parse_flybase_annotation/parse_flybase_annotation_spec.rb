require 'spec_helper'

module ParseFlybaseAnnotation

describe "parse_annotation_string" do
  it "should parse tabbed columns into Openstruct" do
    annotation_string =
      "585     CG11023-RA      chr2L   +       7528    9491    7679    9276    3       7528,8228,8667, 8116,8589,9491,"
    result = OpenStruct.new(
      {
        'chromosome' => '2L',
        'strand'     => '+',
        'mrna_id'    => 9276,
        'segments'   => [[7528,8116],[8228,8589],[8667,9491]]
      })
    ParseFlybaseAnnotation
      .parse_annotation_string(annotation_string)
      .should == result
  end
end

end

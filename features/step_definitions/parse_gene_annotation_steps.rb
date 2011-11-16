require 'fakefs/safe'
require 'json'

Before do
  FakeFS.activate!
end

After do
  FakeFS::FileSystem.clear
  FakeFS.deactivate!
end

Given /^the annotation/ do |annotation|
  @annotation_file = File.open('annotation','w') do |file|
    file << annotation
  end
end

When /^I parse annotation/ do
  @result = ParseFlybaseAnnotation.parse('annotation')
end

Then /^there should be (\d+) mrnas/ do |number|
  @result['mrnas'].count.should == number.to_i
end

Then /^there should be (\d+) exons/ do |number|
  @result['exons'].count.should == number.to_i
end

Then /^there should be mrna/ do |table|
  mrna = ParseFlybaseAnnotation::Mrna.new(Hash[table.raw])
  mrna.exons = JSON.parse(mrna.exons)
  @result['mrnas'].should include(mrna)
end

Then /^there should be exon/ do |table|
  exon = ParseFlybaseAnnotation::Exon.new(Hash[table.raw])
  exon.mrnas = JSON.parse(exon.mrnas)
  exon.start = exon.start.to_i
  exon.stop  = exon.stop.to_i
  @result['exons'].should include(exon)
end

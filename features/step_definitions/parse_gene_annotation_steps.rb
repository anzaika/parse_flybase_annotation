require 'fakefs/safe'
require 'json'

Before do
  FakeFS.activate!
end

After do
  FakeFS::FileSystem.clear
  FakeFS.deactivate!
end

def create_exon_from_table( table )
  exon =
    ParseFlybaseAnnotation::Exon.new(Hash[
      ['splicing','start','stop','chromosome','mrnas'].zip(table.raw.first)
    ])
  exon.mrnas = JSON.parse(exon.mrnas)
  exon.start = exon.start.to_i
  exon.stop  = exon.stop.to_i
  exon
end

def create_mrna_from_table( table )
  mrna =
    ParseFlybaseAnnotation::Mrna.new(Hash[
      ['mrna_id','gene_id','strand','chromosome','exons'].zip(table.raw.first)
  ])
  mrna.exons = JSON.parse(mrna.exons)
  mrna
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
  @result['mrnas'].count.should == number
end

Then /^there should be (\d+) exons/ do |number|
  @result['exons'].count.should == number
end

Then /^there should be mrna/ do |table|
  mrna = create_mrna_from_table( table )
  @result['mrnas'].should include(mrna)
end

Then /^there should be exon/ do |table|
  exon = create_exon_from_table(table)
  @result['exons'].should include(exon)
end

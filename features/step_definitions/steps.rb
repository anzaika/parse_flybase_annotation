require 'fakefs/safe'
require 'json'

Before do
  FakeFS.activate!
end

After do
  FakeFS::FileSystem.clear
  FakeFS.deactivate!
end

def table_to_exons( table )
  table_map = [
    :splicing,
    :start,
    :stop,
    :chromosome,
    :mrnas
  ]
  table.raw.map do |row|
    params = Hash[table_map.zip(row)]
    params[:start] = params[:start].to_i
    params[:stop]  = params[:stop].to_i
    params[:mrnas] = JSON.parse(params[:mrnas])
    ParseFlybaseAnnotation::Exon.new(params)
  end
end

def table_to_mrnas( table )
  table_map = [
    :mrna_id,
    :gene_id,
    :strand,
    :chromosome,
    :exons
  ]
  table.raw.map do |row|
    params = Hash[table_map.zip(row)]
    params[:exons] = JSON.parse(params[:exons])
    ParseFlybaseAnnotation::Mrna.new(params)
  end
end

Given /^the annotation:$/ do |annotation|
  @annotation_file = File.open('annotation','w') do |file|
    file << annotation
  end
end

When /^I parse annotation$/ do
  @result = ParseFlybaseAnnotation.parse('annotation')
end

Then /^there should be (\d+) mrnas$/ do |number|
  @result['mrnas'].count.should == number
end

Then /^there should be (\d+) exons$/ do |number|
  @result['exons'].count.should == number
end

Then /^there should be mrnas:$/ do |table|
  table_to_mrnas( table ).each do |mrna|
    @result['mrnas'].should include mrna
  end
end

Then /^there should be exons:$/ do |table|
  table_to_exons( table ).each do |exon|
    @result['exons'].should include exon
  end
end

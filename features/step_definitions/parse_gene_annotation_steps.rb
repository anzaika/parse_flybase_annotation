require 'fakefs/safe'

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

Then /^there should be 1 mrna/ do
  @result.find{|obj| obj.class == ParseFlybaseAnnotation::Mrna}
    .count.should == 1
end

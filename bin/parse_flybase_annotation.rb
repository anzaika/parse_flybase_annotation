require '../lib/parse_flybase_annotation'

File.file?(ARGV[0]) or
  raise 'You should pass valid path to flybase annotation file'

ParseFlybaseAnnotation.parse_and_upload(ARGV[0])

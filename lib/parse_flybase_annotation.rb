lib_dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'bundler/setup'

require 'my_ruby_extensions'

require "parse_flybase_annotation/main"
require "parse_flybase_annotation/segment"
require "parse_flybase_annotation/mrna"
require "parse_flybase_annotation/version"


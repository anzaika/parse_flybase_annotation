require_relative "parse_flybase_annotation/main"
require_relative "parse_flybase_annotation/exon"
require_relative "parse_flybase_annotation/mrna"
require_relative "parse_flybase_annotation/db"
require_relative "parse_flybase_annotation/version"

class Array
  alias :old_map :map

  def map(symbol=nil)
    if block_given?
      self.old_map{|i| yield(i)}
    else
      self.old_map{|i| i.send(symbol)}
    end
  end
end

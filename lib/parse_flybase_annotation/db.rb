require 'mongo'

module ParseFlybaseAnnotation
  class DB

    def initialize(host, db_name)
      @connection =
        Mongo::Connection
          .new(host)
          .db(db_name)
    end

    def upload_annotation( hash )
      upload_mrnas(hash['mrnas'])
      upload_exons(hash['exons'])
    end

    def upload_mrnas( collection )
      collection.each do |el|
        @connection['mrnas']
          .insert(el.marshal_dump)
      end
    end

    def upload_exons( collection )
      collection.each do |el|
        @connection['exons']
          .insert(el.marshal_dump)
      end
    end

  end
end

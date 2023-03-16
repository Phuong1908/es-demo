module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    mapping do
      indexes :artist, type: :text, analyzer: 'english'
      indexes :title, type: :text, analyzer: 'english'
      indexes :lyrics, type: :text, analyzer: 'english'
      indexes :genre, type: :keyword
    end

    def self.search(query)
      # build and run search
      params = {
        query: {
          multi_match: {
            query: query, 
            fields: [ :title, :artist, :lyrics ] 
          },
        },
      }

      self.__elasticsearch__.search(params)
    end
  end
end

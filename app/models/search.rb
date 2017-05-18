class Search < ActiveRecord::Base

  OBJECTS = %w[Questions Answers Comments Users All].freeze

  def self.find(query, object)
    return nil if query.try(:blank?) || !OBJECTS.include?(object)
    query = ThinkingSphinx::Query.escape(query)
    if object == 'All'
      ThinkingSphinx.search query
    else
      ThinkingSphinx.search(query, classes: [object.classify.constantize])
    end
  end
end

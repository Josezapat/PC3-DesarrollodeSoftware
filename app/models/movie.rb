class Movie < ActiveRecord::Base
    def self.all_ratings
      # Lógica para obtener todas las clasificaciones posibles
      ['G', 'PG', 'PG-13', 'R']
    end
  
    def self.with_ratings(ratings_list)
      return all if ratings_list.nil? || ratings_list.empty?
  
      where(rating: ratings_list)
    end
  end
  
  

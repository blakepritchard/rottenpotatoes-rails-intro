class Movie < ActiveRecord::Base
    
    def self.all_ratings
        @all_ratings = ['G','PG','PG-13','R']
    end
    
    def self.default_ratings
        defaults = {}
        self.all_ratings.each {|rating| defaults.store(rating, 1) }
        @default_ratings = defaults
    end
    
end

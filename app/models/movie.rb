class Movie < ActiveRecord::Base
    def self.all_ratings
        ['G','PG','PG-13']
    end
end

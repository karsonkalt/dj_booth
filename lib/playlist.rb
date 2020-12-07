class Playlist

    attr_accessor :title
  
    @@all = []
  
    def initialize
      @@all << self
    end
  
    # Class Methods

    def self.all
      @@all
    end

    def self.reset_all
        @@all.clear
    end

end
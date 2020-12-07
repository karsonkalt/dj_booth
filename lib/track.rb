class Track
    attr_accessor :title, :artist, :label, :timestamp, :number, :confirmation_status, :playlist

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


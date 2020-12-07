class Playlist

    attr_accessor :title
  
    @@all = []
  
    def initialize
      @@all << self
    end

    def print_set
      mashup_number = 0
      
      tracks_in_set = Track.all.select do |track|
        track.playlist == self
      end
      
      tracks_in_set.each do |track|
  
        if track.number != mashup_number
          mashup_number = track.number
          puts "Track #{track.number}".colorize(:blue)
        else
          puts "Track played together with previous track".colorize(:blue)
        end
  
        if track.timestamp != ""
          puts "  Cue Time: #{track.timestamp}"
        end
        
        if track.label != "Unreleased"
          puts "  #{track.title} -- #{track.artist} [#{track.label}]"
        else
          puts "  #{track.title} -- #{track.artist} [" + track.label.to_s.colorize(:red) + "]"
        end

        if track.confirmation_status == "Unconfirmed"
          puts "  Track information not confirmed".colorize(:red)
        end

        puts ""
      end
    end
  
    # Class Methods

    def self.all
      @@all
    end

    def self.reset_all
        @@all.clear
    end

end
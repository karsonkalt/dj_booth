class CLI
    def initialize
        puts ''
        puts ''
        puts ' ____      _   ____   ___   ___ _____ _   _ '.colorize(:blue)
        puts '|  _ \    | | | __ ) / _ \ / _ \_   _| | | |'.colorize(:blue)
        puts '| | | |_  | | |  _ \| | | | | | || | | |_| |'.colorize(:blue)
        puts '| |_| | |_| | | |_) | |_| | |_| || | |  _  |'.colorize(:blue)
        puts '|____/ \___/  |____/ \___/ \___/ |_| |_| |_|'.colorize(:blue)
    end

    def self.loading_dots
        print ".".colorize(:green)
    end
    
    def puts_announcement(arg)
        puts ""
        puts arg.upcase.colorize(:blue)
        length = arg.split("").count
        (1..length).each do |num|
            print "-"
        end
        puts ""
    end
    
    def puts_main_menu
        puts_announcement("Main Menu")
        puts ""
        puts "There are " + Track.all.count.to_s.colorize(:blue) + " tracks in the program."
        puts "There are " + Playlist.all.count.to_s.colorize(:blue) + " playlists in the program."
        puts ""
        puts "A".colorize(:green) + "  - Add playlist by URL"
        puts "P".colorize(:green) + "  - View playlists"
        puts "UR".colorize(:green) + " - View unreleased tracks"
        puts "UN".colorize(:green) + " - View tracks with unconfirmed status"
        puts "S".colorize(:green) + "  - Search for tracks by artist"
        puts ""
        puts "E".colorize(:green) + "  - Exit"
    end
    
    def input_loop
        puts_main_menu
        input = gets.chomp
    
        if input.upcase == "A"
            puts ""
            puts "Enter the 1001tracklist.com URL of a playlist you would like to add."
            input = gets.chomp
            if input.start_with?('https://www.1001tracklists.com/tracklist')
                Scraper.new(input)
                puts ""
                puts "Done".colorize(:green)
                input_loop
            else
                puts "invlaid link"
                input_loop
            end
    
        elsif input.upcase == "UR"
            puts_announcement("Unreleased Tracks")
            unreleased_list = Track.all.select do |track|
                track.label == "Unreleased"
            end
            id_counter = 0
            unreleased_list.each do |track|
                if track.title == "ID" && track.artist == "ID"
                    id_counter += 1
                else
                    puts "#{track.title} -- #{track.artist}"
                end
            end
    
            if id_counter > 0 && unreleased_list.length > 0
                puts ""
                puts "There are also " + id_counter.to_s.colorize(:blue) + " unreleased tracks in the program with unknown artists and unknown track titles."
            elsif id_counter > 0 && unreleased_list.length == 0
                puts ""
                puts "There are " + id_counter.to_s.colorize(:blue) + " unreleased tracks in the program with unknown artists and unknown track titles."
            end
            input_loop
    
        elsif input.upcase == "E" || input.upcase == "EXIT"
            puts_announcement("Exiting")
    
        elsif input.upcase == "P"
            puts_announcement("View Playlists")
            @counter = 0
            Playlist.all.each do |playlist|
                @counter += 1
                puts "#{@counter}. #{playlist.title}"
            end
            puts ""

            def playlist_loop
                puts "Enter a playlist number to view tracks or type " + "BACK".colorize(:red) + " to go back"
                input = gets.chomp
                if input.upcase == "BACK"
                elsif input.to_i > 0 && input.to_i <= @counter
                    playlist = Playlist.all[input.to_i - 1]
                    puts_announcement("#{playlist.title}")
                    print_playlist(playlist)
                else
                    puts "Invalid response."
                    playlist_loop
                end
            end

            playlist_loop
            input_loop
    
        elsif input.upcase == "UN"
            puts_announcement("UNCONFIRMED TRACKS")
            unconfirmed_list = Track.all.select do |track|
                track.confirmation_status == "Unconfirmed"
            end
    
            unconfirmed_list.each do |track|
                puts "#{track.title} -- #{track.artist} played in #{track.playlist.title} at #{track.timestamp}"
            end
            input_loop
    
        elsif input.upcase == "S"
            puts ""
            puts "Enter an artist name to search for"
            input = gets.chomp
            puts ""
            search_tracks = Track.all.select do |track|
                track.artist.upcase == input.upcase
            end

            if search_tracks[0] != nil
                puts_announcement("TRACKS BY #{search_tracks.first.artist.upcase}")
                search_tracks.each do |track|
                    puts "#{track.title} [#{track.label}]"
                end
            else
                puts "No search results"
            end
            input_loop
    
        else
            puts ""
            puts "Invalid response"
            input_loop
            
        end
    end

    def print_playlist(playlist)
        mashup_number = 0
        
        tracks_in_set = Track.all.select do |track|
          track.playlist == playlist
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

end
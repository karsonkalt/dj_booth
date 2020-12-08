class Scraper

    def initialize(input)
        @input = input
        @playlist = Playlist.new
        self.make_tracks
    end

    def get_page
        doc = Nokogiri::HTML(open(@input))
        @playlist.title = doc.css("#pageTitle").text
        doc
    end 

    def get_tracks
        self.get_page.css(".tlpItem")
    end 

    def make_tracks
        #Variable to use if mashup track
        mashup_number = 0

        self.get_tracks.each do |post|
            CLI.loading_dots

            track = Track.new
            track.playlist = @playlist

            #Variables to be parsed
            track_info = post.css(".trackFormat").css(".notranslate").text
            track_label = post.css(".trackLabel").text.split(/\[|\]/)
            track_number = post.css(".tlFontLarge").text.strip.to_i

            #Assign to object
            track.artist = track_info.split(" - ")[0]
            track.title = track_info.split(" - ")[1]
            track.timestamp = post.css(".cueValueField").text.strip

            #Check to see if any user confirmed it was played
            if post.css(".tlUserInfo").text != ""
                track.confirmation_status = "Confirmed"
            else
                track.confirmation_status = "Unconfirmed"
            end

            #If a mashup track, use the track number of the previously played track
            if track_number != 0
                track.number = track_number
                mashup_number = track_number
            else
                track.number = mashup_number
            end

            #If no label for the track, mark it unreleased
            if track_label[1] != nil
                track_label_original = track_label[1].split
                track_label_capitalize = track_label_original.collect do |word|
                    word.capitalize
                end
                track.label = track_label_capitalize.join(" ")
            else
                track.label = "Unreleased"
            end
        end
    end

end
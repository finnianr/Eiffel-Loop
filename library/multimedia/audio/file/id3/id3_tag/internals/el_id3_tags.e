note
	description: "Summary description for {EL_ID3_TAGS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "4"

class
	EL_ID3_TAGS

feature -- Basic tag frame codes

	Album_picture: STRING = "APIC"

	Artist: STRING = "TPE1"

	Album_artist: STRING = "TPE2"

	Album: STRING = "TALB"

	Composer: STRING = "TCOM"

	Comment: STRING = "COMM"

	Duration: STRING = "TLEN"

	Genre: STRING = "TCON"

	Recording_time: STRING = "TDRC"

	Track: STRING = "TRCK"

	Title: STRING = "TIT2"

	Unique_file_ID: STRING = "UFID"

	User_text: STRING = "TXXX"

	Year: STRING = "TYER"
		-- Deprecated in the 2.4 ID3 version

	Basic: ARRAY [STRING]
			--
		once
			Result := << Artist, Album_artist, Album, Composer, Duration, Genre, Year, Recording_time, Title, Track >>
			Result.compare_objects
		end

end

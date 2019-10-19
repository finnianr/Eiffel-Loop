note
	description: "Id3 tags"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	ID3_TAGS

feature -- Basic tag frame codes

	Album_picture: STRING = "APIC"

	Artist: STRING = "TPE1"

	Album_artist: STRING = "TPE2"

	Album: STRING = "TALB"

	Beats_per_minute: STRING = "TBPM"

	Composer: STRING = "TCOM"

	Comment: STRING = "COMM"

	Duration: STRING = "TLEN"
		-- The 'Length' frame contains the length of the audiofile in milliseconds, represented as a numeric string.

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
			Result := <<
				Artist, Album_artist, Album, Composer, Duration, Genre, Year, Recording_time, Title, Track
			>>
			Result.compare_objects
		end

end

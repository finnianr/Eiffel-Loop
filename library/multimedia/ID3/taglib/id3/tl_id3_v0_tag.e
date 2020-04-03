note
	description: "A default ID3 tag with version = 0"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-24 9:07:27 GMT (Tuesday 24th March 2020)"
	revision: "9"

class
	TL_ID3_V0_TAG

inherit
	TL_ID3_TAG
		redefine
			album, artist, comment, genre, title, track, year,
			set_album, set_artist, set_comment, set_genre, set_title, set_track, set_year
		end

feature -- Fields

	version, type: INTEGER
		do
		end

feature {NONE} -- Implementation

	album, artist, comment, genre, title: ZSTRING
		do
			create Result.make_empty
		end

	track, year: INTEGER
		do
		end

	set_album, set_artist, set_comment, set_genre, set_title (a_text: ZSTRING)
		do
		end

	set_track, set_year (n: INTEGER)
		do

		end
end

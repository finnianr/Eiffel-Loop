note
	description: "[
		Fields mapping to Rhythmbox XML Internet Radio station data

		**Example**

			<entry type="iradio">
				<title>WSUM 91.7 FM (University of Wisconsin)</title>
				<genre>College Radio</genre>
				<artist></artist>
				<album></album>
				<location>http://vu.wsum.wisc.edu/wsumlive.m3u</location>
				<date>0</date>
				<media-type>application/octet-stream</media-type>
			</entry>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-16 15:09:14 GMT (Sunday 16th October 2022)"
	revision: "4"

deferred class
	RBOX_IRADIO_FIELDS

inherit
	RHYTHMBOX_CONSTANTS
		rename
			Media_type as Media_types
		end

feature -- XML field names

	album: ZSTRING

	artist: ZSTRING

	date: INTEGER
		-- Recording date in days

	genre: ZSTRING

	hidden: NATURAL_8

	location: EL_URI

	media_type: STRING

	rating: DOUBLE

	title: ZSTRING

feature -- Status query

	is_hidden: BOOLEAN
		do
			Result := hidden.to_boolean
		end

	is_playlist: BOOLEAN
		do
			Result := genre ~ Playlist_genre
		end

feature -- Status setting

	hide
		do
			hidden := 1
		end

	show
		do
			hidden := 0
		end

feature -- Element change

	set_album (a_album: like album)
			--
		do
			Album_set.put (a_album)
			album := Album_set.found_item
		end

	set_artist (a_artist: like artist)
			--
		do
			Artist_set.put (a_artist)
			artist := Artist_set.found_item
		end

	set_genre (a_genre: like genre)
			--
		do
			Genre_set.put (a_genre)
			genre := Genre_set.found_item
		end

	set_media_type (a_media_type: like media_type)
		do
			Media_type_set.put (a_media_type)
			media_type := Media_type_set.found_item
		end

	set_recording_year (a_year: INTEGER)
		do
			date := a_year * Days_in_year
		end

	set_title (a_title: like title)
			--
		do
			Title_set.put (a_title)
			title := Title_set.found_item
		end

feature {NONE} -- Constants

	Album_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (100)
		end

	Artist_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (100)
		end

	Days_in_year: INTEGER = 365

	Genre_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (50)
		end

	Media_type_set: EL_HASH_SET [STRING]
		once
			create Result.make_from (Media_type_list, True)
		end

	Title_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (100)
		end

end
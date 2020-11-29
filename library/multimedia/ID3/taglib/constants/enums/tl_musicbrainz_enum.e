note
	description: "[
		Enumeration of fields described in [https://picard.musicbrainz.org/docs/mappings/ Tag Mappings document]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-29 11:11:59 GMT (Sunday 29th November 2020)"
	revision: "3"

class
	TL_MUSICBRAINZ_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			import_name as import_default,
			export_name as to_english_title,
			export_to_title as export_to_musicbrainz_title
		redefine
			export_to_musicbrainz_title
		end

create
	make

feature -- Enum codes

	album_artist_id: NATURAL_8

	album_id: NATURAL_8

	artist_id: NATURAL_8

	release_track_id: NATURAL_8

feature -- Access

	identifier (a_value: NATURAL_8): STRING_8
		local
			table: like name_by_value
		do
			if a_value = release_track_id then
				Result := Musicbrainz_trackid
			else
				table := field_name_by_value
				if table.has_key (a_value) then
					Result := to_camel_case (table.found_item, False)
					Result.prepend (Musicbrainz)
					Result [Musicbrainz.count] := '_'
					Result.to_lower
				else
					create Result.make_empty
				end
			end
		end

feature {NONE} -- Implementation

	export_to_musicbrainz_title (name_in, title_out: STRING; separator_out: CHARACTER)
		do
			Precursor (name_in, title_out, separator_out)
			title_out.prepend (Musicbrainz)
		end

feature {NONE} -- Constants

	Musicbrainz: STRING = "MusicBrainz "
		-- identifier with trailing space

	Musicbrainz_trackid: STRING = "musicbrainz_trackid"
end
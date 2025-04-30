note
	description: "[
		Enumeration of fields described in [https://picard.musicbrainz.org/docs/mappings/ Tag Mappings document]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 8:12:33 GMT (Wednesday 30th April 2025)"
	revision: "13"

class
	TL_MUSICBRAINZ_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_text,
			name_translater as Musicbrainz_naming
		end

	EL_STRING_8_CONSTANTS

create
	make

feature -- Enum codes

	album_artist_id: NATURAL_8

	album_id: NATURAL_8

	artist_id: NATURAL_8

	release_track_id: NATURAL_8

feature -- Access

	identifier (a_value: NATURAL_8): STRING_8
		do
			if a_value = release_track_id then
				Result := Musicbrainz_trackid

			elseif attached field_name (a_value) as value_name then
				if value_name.count > 0 then
					Result := Musicbrainz_ + Id_translater.exported (value_name)
				else
					Result := Empty_string_8
				end
			end
		end

feature {NONE} -- Constants

	Musicbrainz_naming: TL_MUSICBRAINZ_TRANSLATER
		once
			create Result.make
		end

	Musicbrainz_: STRING = "musicbrainz_"

	Musicbrainz_trackid: STRING = "musicbrainz_trackid"

	ID_translater: EL_CAMEL_CASE_TRANSLATER
		once
			create Result.make
		end

end
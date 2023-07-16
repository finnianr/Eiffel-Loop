note
	description: "[
		Enumeration of fields described in [https://picard.musicbrainz.org/docs/mappings/ Tag Mappings document]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-16 11:44:48 GMT (Sunday 16th July 2023)"
	revision: "7"

class
	TL_MUSICBRAINZ_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			foreign_naming as Musicbrainz_naming
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
					Result := Musicbrainz_ + Id_translater.exported (table.found_item)
				else
					create Result.make_empty
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
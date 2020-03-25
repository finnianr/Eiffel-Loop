note
	description: "MPEG file meta-data with additional [https://musicbrainz.org/ MusicBrainz data]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-24 12:00:00 GMT (Tuesday 24th March 2020)"
	revision: "2"

class
	TL_MUSICBRAINZ_MPEG_FILE

inherit
	TL_MPEG_FILE

	TL_MUSICBRAINZ_CONSTANTS
		export
			{ANY} Musicbrainz_fields
		end

create
	make

feature -- Element change

	set_mb_field (name: STRING; value: READABLE_STRING_GENERAL)
		require
			version_2: tag.version = 2
		local
			mb_name: ZSTRING
		do
			mb_name := Musicbrainz_prefix
			mb_name.append_string_general (name)
			if value.is_empty then
				tag.remove_user_text (mb_name)
			else
				tag.set_user_text (mb_name, value)
			end
			mb_name.remove_tail (mb_name.count)
		ensure
			prefix_unchanged: old Musicbrainz_prefix ~ Musicbrainz_prefix
		end

	set_mb_track_id (track_id: STRING)
		require
			version_2: tag.version = 2
		do
			tag.set_unique_id (Http_musicbrainz_org, track_id)
		end

end

note
	description: "MPEG file meta-data with additional [https://musicbrainz.org/ MusicBrainz data]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-20 10:29:57 GMT (Friday 20th March 2020)"
	revision: "1"

class
	TL_MUSICBRAINZ_MPEG_FILE

inherit
	TL_MPEG_FILE

	TL_MUSICBRAINZ_CONSTANTS
		export
			{ANY} Music_brainz_fields
		end

create
	make

feature -- Element change

	set_mb_field (name: STRING; value: READABLE_STRING_GENERAL)
		require
			valid_name: Music_brainz_fields.has (name)
		local
			mb_name: ZSTRING
		do
			mb_name := Music_brainz_prefix + name
			if value.is_empty then
				tag.remove_user_text (mb_name)
			else
				tag.set_user_text (mb_name, value)
			end
		end

	set_mb_track_id (track_id: STRING)
		do
			tag.set_unique_id (Http_musicbrainz_org, track_id)
		end

end

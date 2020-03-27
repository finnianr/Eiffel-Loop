note
	description: "MPEG file meta-data with additional [https://musicbrainz.org/ MusicBrainz data]"
	notes: "See: [https://picard.musicbrainz.org/docs/mappings/ Field mappings document]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-26 13:02:15 GMT (Thursday 26th March 2020)"
	revision: "3"

class
	TL_MUSICBRAINZ_MPEG_FILE

inherit
	TL_MPEG_FILE

	TL_MUSICBRAINZ_CONSTANTS

create
	make

feature -- Access

	album_artist_id: STRING
		do
			Result := field (MB_field.albumartistid)
		end

	album_id: STRING
		do
			Result := field (MB_field.albumid)
		end

	artist_id: STRING
		do
			Result := field (MB_field.artistid)
		end

	artist_sort_name: ZSTRING
		do
			Result := field (MB_field.artistsortname)
		end

	field (name: STRING): ZSTRING
		do
			Result := tag.user_text (qualified_name (name))
		end

	track_id: STRING
		-- TXXX:MusicBrainz Release Track Id
		do
			Result := field (MB_field.trackid)
		end

	recording_id: STRING
		do
			Result := tag.unique_id (Http_musicbrainz_org).identifier
		end

feature -- Element change

	set_album_artist_id (id: STRING)
		do
			set_field (MB_field.albumartistid, id)
		end

	set_album_id (id: STRING)
		do
			set_field (MB_field.albumid, id)
		end

	set_artist_id (id: STRING)
		do
			set_field (MB_field.artistid, id)
		end

	set_artist_sort_name (name: READABLE_STRING_GENERAL)
		do
			set_field (MB_field.artistsortname, name)
		end

	set_field (name: STRING; value: READABLE_STRING_GENERAL)
		require
			version_2: tag.version = 2
		do
			if value.is_empty then
				tag.remove_user_text (qualified_name (name))
			else
				tag.set_user_text (qualified_name (name), value)
			end
		ensure
			set: not value.is_empty implies value.same_string (field (name))
		end

	set_track_id (id: STRING)
		-- set TXXX:MusicBrainz Release Track Id
		do
			set_field (MB_field.trackid, id)
		end

	set_recording_id (id: STRING)
		require
			version_2: tag.version = 2
		do
			tag.set_unique_id (Http_musicbrainz_org, id)
		ensure
			set: id ~ recording_id
		end

feature {NONE} -- Implementation

	qualified_name (name: STRING): ZSTRING
		do
			Result := Name_buffer
			Result.wipe_out
			Result.append_string_general (name)
			if not Result.starts_with (Musicbrainz_prefix) then
				Result.prepend (Musicbrainz_prefix)
			end
		end

feature {NONE} -- Constants

	Name_buffer: ZSTRING
		once
			create Result.make_empty
		end

end

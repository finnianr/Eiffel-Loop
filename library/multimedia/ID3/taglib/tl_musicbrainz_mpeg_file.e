note
	description: "MPEG file meta-data with additional [https://musicbrainz.org/ MusicBrainz data]"
	notes: "See: [https://picard.musicbrainz.org/docs/mappings/ Field mappings document]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-20 13:24:23 GMT (Friday 20th November 2020)"
	revision: "6"

class
	TL_MUSICBRAINZ_MPEG_FILE

inherit
	TL_MPEG_FILE

	TL_SHARED_MUSICBRAINZ_ENUM

	TL_SHARED_FRAME_ID_ENUM

create
	make

feature -- Access

	album_artist_id: STRING
		do
			Result := mb_field (Musicbrainz.album_artist_id)
		end

	album_id: STRING
		do
			Result := mb_field (Musicbrainz.album_id)
		end

	artist_id: STRING
		do
			Result := mb_field (Musicbrainz.artist_id)
		end

	artist_sort_name: ZSTRING
		do
			Result := tag.field_text (Frame_id.TSOP)
		end

	recording_id: STRING
		do
			Result := tag.unique_id (Http_musicbrainz_org).identifier
		end

	track_id: STRING
		-- TXXX:MusicBrainz Release Track Id
		do
			Result := mb_field (Musicbrainz.release_track_id)
		end

feature -- Element change

	set_album_artist_id (id: STRING)
		do
			set_mb_field (Musicbrainz.album_artist_id, id)
		end

	set_album_id (id: STRING)
		do
			set_mb_field (Musicbrainz.album_id, id)
		end

	set_artist_id (id: STRING)
		do
			set_mb_field (Musicbrainz.artist_id, id)
		end

	set_artist_sort_name (name: READABLE_STRING_GENERAL)
		do
			tag.set_field_text (Frame_id.TSOP, name)
		ensure
			set: name.same_string (artist_sort_name)
		end

	set_recording_id (id: STRING)
		require
			version_2: tag.version = 2
		do
			if id.is_empty then
				tag.remove_unique_id (Http_musicbrainz_org)
			else
				tag.set_unique_id (Http_musicbrainz_org, id)
			end
		ensure
			set: id ~ recording_id
		end

	set_track_id (id: STRING)
		-- set TXXX:MusicBrainz Release Track Id
		do
			set_mb_field (Musicbrainz.release_track_id, id)
		end

feature -- Removal

	remove_mb_field (enum: NATURAL_8)
		do
			tag.remove_user_text (Musicbrainz.name (enum))
			tag.remove_user_text (Musicbrainz.identifier (enum))
		end

feature {NONE} -- Implementation

	mb_field (enum: NATURAL_8): ZSTRING
		do
			Result := tag.user_text (Musicbrainz.name (enum))
			if Result.is_empty then
				Result := tag.user_text (Musicbrainz.identifier (enum))
			end
		end

	set_mb_field (enum: NATURAL_8; text: READABLE_STRING_GENERAL)
		-- set double fields
		do
			across << Musicbrainz.name (enum), Musicbrainz.identifier (enum) >> as id loop
				if text.is_empty then
					tag.remove_user_text (id.item)
				else
					tag.set_user_text (id.item, text)
				end
			end
		ensure
			set: text.same_string (mb_field (enum))
		end

feature {NONE} -- Constants

	Http_musicbrainz_org: ZSTRING
		once
			Result := "http://musicbrainz.org"
		end

end
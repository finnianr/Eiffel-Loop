note
	description: "Task to query or edit ID3 tag information"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-05 7:20:59 GMT (Thursday 5th September 2019)"
	revision: "1"

deferred class
	ID3_TASK

inherit
	RBOX_MANAGEMENT_TASK

	ID3_TAG_INFO_ROUTINES undefine is_equal end

feature {NONE} -- Constants

	Musicbrainz_album_id_set: ARRAY [ZSTRING]
			-- Both fields need to be set in ID3 info otherwise
			-- Rhythmbox changes musicbrainz_albumid to match "MusicBrainz Album Id"
		once
			Result := << "MusicBrainz Album Id", "musicbrainz_albumid" >>
		end

end

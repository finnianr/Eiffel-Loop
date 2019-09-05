note
	description: "Task to query or edit ID3 tag information"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

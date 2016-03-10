note
	description: "Summary description for {RBOX_SONG_ID3_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RBOX_SONG_ID3_INFO

inherit
	EL_ID3_INFO
		rename
			make_version_23 as make_version_23_from_other
		end


create
	make

feature {NONE} -- Initialization

	make_version_23 (song: RBOX_SONG)
		do

		end

end

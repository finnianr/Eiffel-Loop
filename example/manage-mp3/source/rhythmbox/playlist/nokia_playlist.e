note
	description: "Summary description for {NOKIA_PLAYLIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NOKIA_PLAYLIST

inherit
	M3U_PLAYLIST
		redefine
			Template, relative_path
		end

create
	make

feature {NONE} -- Implementation

	relative_path (song: RBOX_SONG): EL_FILE_PATH
		do
			Result := Precursor (song).as_windows
		end

feature {NONE} -- Evolicity fields

	Template: STRING
			-- Windows compatible paths are required for Nokia phones
		once
			Result := "[
				#across $playlist as $song loop
				$playlist_root\Music\$song.item.relative_path
				#end
			]"
		end
end

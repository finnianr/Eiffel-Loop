note
	description: "Summary description for {NOKIA_PLAYLIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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
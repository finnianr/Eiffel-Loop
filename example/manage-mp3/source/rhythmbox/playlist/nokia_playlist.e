note
	description: "Nokia playlist"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

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
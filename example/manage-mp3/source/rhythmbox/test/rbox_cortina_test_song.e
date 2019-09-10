note
	description: "Rbox cortina test song"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-06 21:00:42 GMT (Friday 6th September 2019)"
	revision: "2"

class
	RBOX_CORTINA_TEST_SONG

inherit
	RBOX_CORTINA_SONG
		undefine
			update_file_info
		redefine
			new_audio_id
		end

	RBOX_TEST_SONG
		rename
			make as make_song
		redefine
			new_audio_id
		end

	EL_MODULE_DIGEST

create
	make

feature {NONE} -- Implementation

	new_audio_id: like audio_id
		-- workaround for the fact that the MP3 test data is not consistent between runs
		-- bit of a mystery why
		do
			Result := Digest.sha_256 (title.to_utf_8).to_uuid
		end

end

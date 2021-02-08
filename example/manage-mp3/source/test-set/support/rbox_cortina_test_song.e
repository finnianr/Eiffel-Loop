note
	description: "Rbox cortina test song"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-08 18:22:07 GMT (Monday 8th February 2021)"
	revision: "5"

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
			make as make_default
		redefine
			new_audio_id
		end

	EL_MODULE_DIGEST

create
	make

feature {NONE} -- Implementation

	new_audio_id: EL_UUID
		-- workaround for the fact that the MP3 test data is not consistent between runs
		-- bit of a mystery why
		do
			Result := Digest.sha_256 (title.to_utf_8 (False)).to_uuid
		end

end
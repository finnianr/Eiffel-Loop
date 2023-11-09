note
	description: "Rbox cortina test song"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 23:25:21 GMT (Wednesday 8th November 2023)"
	revision: "7"

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

	EL_SHARED_STRING_8_BUFFER_SCOPES

create
	make

feature {NONE} -- Implementation

	new_audio_id: EL_UUID
		-- workaround for the fact that the MP3 test data is not consistent between runs
		-- bit of a mystery why
		do
			across String_8_scope as scope loop
				Result := Digest.sha_256 (scope.copied_utf_8_item (title)).to_uuid
			end
		end

end
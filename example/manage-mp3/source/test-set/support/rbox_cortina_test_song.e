note
	description: "Rbox cortina test song"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-06 18:49:35 GMT (Wednesday 6th November 2024)"
	revision: "8"

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

	EL_SHARED_STRING_8_BUFFER_POOL

create
	make

feature {NONE} -- Implementation

	new_audio_id: EL_UUID
		-- workaround for the fact that the MP3 test data is not consistent between runs
		-- bit of a mystery why
		do
			if attached String_8_pool.borrowed_item as borrowed then
				Result := Digest.sha_256 (borrowed.copied_general_as_utf_8 (title)).to_uuid
				borrowed.return
			end
		end

end
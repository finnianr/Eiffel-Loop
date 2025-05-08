note
	description: "Object that generates a file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-08 6:30:55 GMT (Thursday 8th May 2025)"
	revision: "1"

deferred class
	EL_FILE_GENERATOR

inherit
	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

feature -- Access

	actual_checksum: NATURAL
		do
			if output_path.exists and then attached crc_generator as crc then
				crc.add_file (output_path)
				Result := crc.checksum
			end
		end

	checksum: NATURAL
		-- expected checksum
		deferred
		end

feature -- Status query

	has_changed: BOOLEAN
		do
			Result := actual_checksum /= checksum
		end

feature {NONE} -- Implementation

	output_path: FILE_PATH
		deferred
		end

end
note
	description: "Add console string to CRC-32 checksum as normalized UTF-8 string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-06 18:35:58 GMT (Wednesday 6th November 2024)"
	revision: "10"

deferred class
	EL_CRC_32_LOG_OUTPUT

inherit
	EL_SHARED_TEST_CRC

	EL_SHARED_STRING_8_BUFFER_POOL

feature {NONE} -- Implementation

	write_console (general: READABLE_STRING_GENERAL)
		local
			s: EL_STRING_8_ROUTINES
		do
			if attached String_8_pool.borrowed_item as borrowed then
				if attached borrowed.copied_general_as_utf_8 (general) as utf_8 then
					if not utf_8.has ('%N') and then utf_8.has ('\') then
						-- normalize file paths as Unix
						s.replace_character (utf_8, '\', '/')
					end
					Test_crc.add_string_8 (utf_8)
				end
				borrowed.return
			end
		end
end
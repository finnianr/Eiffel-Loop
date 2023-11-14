note
	description: "Add console string to CRC-32 checksum as normalized UTF-8 string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-13 21:08:45 GMT (Monday 13th November 2023)"
	revision: "9"

deferred class
	EL_CRC_32_LOG_OUTPUT

inherit
	EL_SHARED_TEST_CRC

	EL_SHARED_STRING_8_BUFFER_SCOPES

feature {NONE} -- Implementation

	write_console (general: READABLE_STRING_GENERAL)
		local
			s: EL_STRING_8_ROUTINES
		do
			across String_8_scope as scope loop
				if attached scope.copied_utf_8_item (general) as utf_8 then
					if not utf_8.has ('%N') and then utf_8.has ('\') then
						-- normalize file paths as Unix
						s.replace_character (utf_8, '\', '/')
					end
					Test_crc.add_string_8 (utf_8)
				end
			end
		end
end
note
	description: "Add console string to CRC-32 checksum as normalized UTF-8 string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 16:29:30 GMT (Wednesday 8th November 2023)"
	revision: "6"

deferred class
	EL_CRC_32_LOG_OUTPUT

inherit
	EL_SHARED_TEST_CRC

	EL_SHARED_STRING_8_CURSOR; EL_SHARED_STRING_8_BUFFER_SCOPES

feature {NONE} -- Implementation

	write_console (general: READABLE_STRING_GENERAL)
		local
			utf: EL_UTF_CONVERTER
		do
			if attached {ZSTRING} general as zstr then
				across String_8_scope as scope loop
					append_to_crc_32 (scope.copied_utf_8_item (zstr))
				end

			elseif attached {READABLE_STRING_8} general as str_8 and then cursor_8 (str_8).all_ascii then
				append_to_crc_32 (str_8)

			else
				across String_8_scope as scope loop
					if attached scope.item as str then
						utf.utf_32_string_into_utf_8_string_8 (general, str)
						append_to_crc_32 (str)
					end
				end
			end
		end

	append_to_crc_32 (utf_8: STRING)
		local
			s: EL_STRING_8_ROUTINES
		do
			if utf_8.has ('\') and then not utf_8.has ('%N') then
				-- normalize file paths as Unix
				s.replace_character (utf_8, '\', '/')
			end
			Test_crc.add_string_8 (utf_8)
		end
end
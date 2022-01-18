note
	description: "Add console string to CRC-32 checksum as normalized UTF-8 string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-18 12:08:20 GMT (Tuesday 18th January 2022)"
	revision: "1"

deferred class
	EL_CRC_32_LOG_OUTPUT

inherit
	EL_SHARED_TEST_CRC

	EL_MODULE_REUSABLE

feature {NONE} -- Implementation

	write_console (general: READABLE_STRING_GENERAL)
		local
			utf: EL_UTF_CONVERTER; s: EL_STRING_8_ROUTINES
		do
			if attached {ZSTRING} general as zstr then
				append_to_crc_32 (zstr.to_utf_8 (False))

			elseif attached {READABLE_STRING_8} general as str_8 and then s.is_ascii (str_8) then
				append_to_crc_32 (str_8)

			else
				across Reuseable.string_8 as reuse loop
					utf.utf_32_string_into_utf_8_string_8 (general, reuse.item)
					append_to_crc_32 (reuse.item)
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
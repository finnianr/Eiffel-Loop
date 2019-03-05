note
	description: "Routines for finding and comparing cyclical redundancy check-sums of string lists"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-05 13:48:46 GMT (Tuesday 5th March 2019)"
	revision: "2"

class
	EL_CRC_32_ROUTINES

inherit
	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

feature -- Access

	lines (list: LINEAR [READABLE_STRING_GENERAL]): NATURAL
		local
			crc: like crc_generator
		do
			crc := crc_generator
			from list.start until list.after loop
				if attached {ZSTRING} list.item as str_z then
					crc.add_string (str_z)
				elseif attached {STRING_8} list.item as str_8 then
					crc.add_string_8 (str_8)
				elseif attached {STRING_32} list.item as str_32 then
					crc.add_string_32 (str_32)
				end
				list.forth
			end
			Result := crc.checksum
		end

	utf_8_file_lines (file_path: EL_FILE_PATH): NATURAL
		-- returns CRC 32 checksum for UTF-8 encoded file as a list of ZSTRING's
		do
			if file_path.exists then
				Result := lines (create {EL_PLAIN_TEXT_LINE_SOURCE}.make (file_path))
			end
		end

feature -- Status report

	is_same (list_1, list_2: LINEAR [ZSTRING]): BOOLEAN
		do
			Result := lines (list_1) = lines (list_2)
		end

	same_as_utf_8_file (list: LINEAR [ZSTRING]; file_path: EL_FILE_PATH): BOOLEAN
		do
			Result := lines (list) = utf_8_file_lines (file_path)
		end
end

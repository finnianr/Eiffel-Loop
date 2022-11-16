note
	description: "CRC 32 checksum routines accessible via [$source EL_MODULE_CHECKSUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	EL_CRC_32_CHECKSUM_ROUTINES

inherit
	ANY

	EL_MODULE_FILE

	EL_FILE_OPEN_ROUTINES

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

feature -- Status query

	is_same (list_1, list_2: ITERABLE [ZSTRING]): BOOLEAN
		do
			Result := string_list (list_1) = string_list (list_2)
		end

	same_as_utf_8_file (list: ITERABLE [ZSTRING]; file_path: FILE_PATH): BOOLEAN
		do
			Result := string_list (list) = utf_8_file_content (file_path)
		end

	has_changed (crc_path: FILE_PATH; checksum: NATURAL): BOOLEAN
		do
			if crc_path.exists then
				Result := File.plain_text (crc_path).to_natural /= checksum
			else
				Result := True
			end
		end

feature -- Measurement

	data (pointer: MANAGED_POINTER): NATURAL
			--
		local
			crc: like crc_generator
		do
			crc := crc_generator
			crc.add_data (pointer)
			Result := crc.checksum
		end

	file_content (path: FILE_PATH): NATURAL
		local
			crc: like crc_generator
		do
			if path.exists then
				crc := crc_generator
				crc.add_file (path)
				Result := crc.checksum
			end
		end

	string_list (list: ITERABLE [READABLE_STRING_GENERAL]): NATURAL
		local
			crc: like crc_generator
		do
			crc := crc_generator
			crc.add_string_list (list)
			Result := crc.checksum
		end

	tuple (a_tuple: TUPLE): NATURAL
		local
			crc: like crc_generator
		do
			crc := crc_generator
			crc.add_tuple (a_tuple)
			Result := crc.checksum
		end

	utf_8_file_content (file_path: FILE_PATH): NATURAL
		-- returns CRC 32 checksum for UTF-8 encoded file as a list of ZSTRING's
		do
			if attached open_lines (file_path, Utf_8) as lines then
				Result := string_list (lines)
			end
		end

end
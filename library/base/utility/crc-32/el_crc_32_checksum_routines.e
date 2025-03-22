note
	description: "CRC 32 checksum routines accessible via ${EL_MODULE_CHECKSUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 13:43:50 GMT (Saturday 22nd March 2025)"
	revision: "15"

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
		do
			if attached crc_generator as crc then
				crc.add_data (pointer)
				Result := crc.checksum
			end
		end

	file_content (path: FILE_PATH): NATURAL
		do
			if path.exists and then attached crc_generator as crc then
				crc.add_file (path)
				Result := crc.checksum
			end
		end

	file_lines (path: FILE_PATH): NATURAL
		do
			if path.exists and then attached crc_generator as crc then
				Result := string_list (File.plain_text_lines (path))
			end
		end

	string (str: ZSTRING): NATURAL
		do
			if attached crc_generator as crc then
				crc.add_string (str)
				Result := crc.checksum
			end
		end

	string_8 (str: READABLE_STRING_8): NATURAL
		do
			if attached crc_generator as crc then
				crc.add_string_8 (str)
				Result := crc.checksum
			end
		end

	string_32 (str: READABLE_STRING_32): NATURAL
		do
			if attached crc_generator as crc then
				crc.add_string_8 (str)
				Result := crc.checksum
			end
		end

	string_list (list: ITERABLE [READABLE_STRING_GENERAL]): NATURAL
		do
			if attached crc_generator as crc then
				crc.add_string_list (list)
				Result := crc.checksum
			end
		end

	tuple (a_tuple: TUPLE): NATURAL
		do
			if attached crc_generator as crc then
				crc.add_tuple (a_tuple)
				Result := crc.checksum
			end
		end

	utf_8_file_content (file_path: FILE_PATH): NATURAL
		-- returns CRC 32 checksum for UTF-8 encoded file as a list of ZSTRING's
		do
			if attached open_lines (file_path, Utf_8) as lines then
				Result := string_list (lines)
			end
		end

end
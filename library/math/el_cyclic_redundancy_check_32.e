note
	description: "CRC32 algorithm described in RFC 1952"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-23 13:52:04 GMT (Tuesday 23rd July 2013)"
	revision: "3"

class
	EL_CYCLIC_REDUNDANCY_CHECK_32

inherit
	EL_MODULE_LOG

	EL_MODULE_FILE_SYSTEM

	STRING_HANDLER

feature -- Access

	checksum: NATURAL

feature -- Element change

	add_directory_tree (tree_path: EL_DIR_PATH)
			--
		local
			file_name_list: EL_FILE_PATH_LIST
		do
			create file_name_list.make (tree_path, "*")
			file_name_list.do_all (agent add_file)
		end

	add_file (file_path: EL_FILE_PATH)
			--
		do
			add_data (File_system.file_data (file_path))
		end

	add_string (str: EL_ASTRING)
			--
		do
			add_string_8 (str)
			add_string_32 (str.foreign_string_32)
		end

	add_string_8 (str: STRING)
			--
		do
			internal_data.set_from_pointer (str.area.base_address, str.count)
			add_data (internal_data)
			internal_data.set_from_pointer (Default_pointer, 0)
		end

	add_string_32 (str: STRING_32)
			--
		do
			internal_data.set_from_pointer (str.area.base_address, str.count * {PLATFORM}.Integer_32_bytes)
			add_data (internal_data)
			internal_data.set_from_pointer (Default_pointer, 0)
		end

	add_character (c: CHARACTER)
			--
		do
			internal_data.set_from_pointer ($c, {PLATFORM}.Character_8_bytes)
			add_data (internal_data)
			internal_data.set_from_pointer (Default_pointer, 0)
		end

	add_integer (n: INTEGER)
			--
		do
			internal_data.set_from_pointer ($n, {PLATFORM}.Integer_32_bytes)
			add_data (internal_data)
			internal_data.set_from_pointer (Default_pointer, 0)
		end

	add_natural (n: NATURAL)
			--
		do
			internal_data.set_from_pointer ($n, {PLATFORM}.Integer_32_bytes)
			add_data (internal_data)
			internal_data.set_from_pointer (Default_pointer, 0)
		end

	add_data (data: MANAGED_POINTER)
			--
		local
	 		i: INTEGER
	 		c, index: NATURAL
		do
			c := checksum.bit_not
			from i := 0 until i = data.count loop
				index := c.bit_xor (data.read_natural_8 (i)) & 0xFF + 1
				c := crc_table.item (index.to_integer_32).bit_xor (c |>> 8)
				i := i + 1
			end
			checksum := c.bit_not
		end

	reset
			--
		do
			checksum := 0
		end

feature {NONE} -- Implementation

	internal_data: MANAGED_POINTER
			--
		once
			create Result.share_from_pointer (Default_pointer, 0)
		end

feature -- Constants

	crc_table: ARRAY [NATURAL]
 			--
	 	local
	 		n, i: INTEGER
	 		c: NATURAL
	 	once
	 		create Result.make (1, 256)
	 		from n := 1 until n > Result.count loop
	 			c := (n - 1).to_natural_32
	 			from i := 1 until i > 8 loop
	 				if (c & 1) /= 0 then
	 					c := (c |>> 1).bit_xor (0xEDB88320)
	 				else
	 					c := c |>> 1
	 				end
	 				i := i + 1
	 			end
	 			Result [n] := c
	 			n := n + 1
	 		end
	 	end

end

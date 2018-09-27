note
	description: "CRC32 algorithm described in RFC 1952"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_CYCLIC_REDUNDANCY_CHECK_32

inherit


	EL_MODULE_FILE_SYSTEM

	STRING_HANDLER

feature -- Access

	checksum: NATURAL

feature -- Element change

	add_directory_tree (tree_path: EL_DIR_PATH)
			--
		do
			File_system.recursive_files (tree_path).do_all (agent add_file)
		end

	add_file (file_path: EL_FILE_PATH)
			--
		do
			add_data (File_system.file_data (file_path))
		end

	add_string (str: ZSTRING)
			--
		do
			add_array (str.area.base_address, str.count, {PLATFORM}.character_8_bytes)
			if str.has_mixed_encoding then
				add_array (str.unencoded_area.base_address, str.unencoded_area.count, {PLATFORM}.character_32_bytes)
			end
		end

	add_string_8 (str: STRING)
			--
		do
			add_array (str.area.base_address, str.count, {PLATFORM}.character_8_bytes)
		end

	add_string_32 (str: STRING_32)
			--
		do
			add_array (str.area.base_address, str.count, {PLATFORM}.character_32_bytes)
		end

	add_character (c: CHARACTER)
			--
		do
			add_array ($c, 1, {PLATFORM}.Character_8_bytes)
		end

	add_integer (n: INTEGER)
			--
		do
			add_array ($n, 1, {PLATFORM}.Integer_32_bytes)
		end

	add_natural (n: NATURAL)
			--
		do
			add_array ($n, 1, {PLATFORM}.Integer_32_bytes)
		end

	add_data (data: MANAGED_POINTER)
			--
		do
			add_array (data.item, data.count, 1)
		end

	reset
			--
		do
			checksum := 0
		end

feature {NONE} -- Implementation

	add_array (array_ptr: POINTER; count, item_bytes: INTEGER)
		local
			data: like Internal_data; i: INTEGER; c, index: NATURAL
		do
			data := Internal_data
			data.set_from_pointer (array_ptr, count * item_bytes)
			c := checksum.bit_not
			from i := 0 until i = data.count loop
				index := c.bit_xor (data.read_natural_8 (i)) & 0xFF + 1
				c := CRC_table.item (index.to_integer_32).bit_xor (c |>> 8)
				i := i + 1
			end
			checksum := c.bit_not
			data.set_from_pointer (Default_pointer, 0)
		end

feature -- Constants

	CRC_table: ARRAY [NATURAL]
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

	Internal_data: MANAGED_POINTER
			--
		once
			create Result.share_from_pointer (Default_pointer, 0)
		end

end

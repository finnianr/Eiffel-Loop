note
	description: "CRC32 algorithm described in [https://tools.ietf.org/rfc/rfc1952.txt IETF RFC 1952"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 15:07:17 GMT (Saturday 19th April 2025)"
	revision: "40"

class
	EL_CYCLIC_REDUNDANCY_CHECK_32

inherit
	EL_WRITABLE
		rename
			write_boolean as add_boolean,
			write_encoded_character_8 as add_character_8,
			write_character_8 as add_character_8,
			write_character_32 as add_character_32,
			write_integer_8 as add_integer_8,
			write_integer_16 as add_integer_16,
			write_integer_32 as add_integer,
			write_integer_64 as add_integer_64,
			write_ise_path as add_ise_path,
			write_natural_8 as add_natural_8,
			write_natural_16 as add_natural_16,
			write_natural_32 as add_natural_32,
			write_natural_64 as add_natural_64,
			write_encoded_string_8 as add_string_8,
			write_real_32 as add_real,
			write_real_64 as add_double,
			write_string as add_string,
			write_string_8 as add_string_8,
			write_string_32 as add_string_32,
			write_string_general as add_string_general,
			write_pointer as add_pointer,
			write_path as add_path
		redefine
			add_ise_path, add_path
		end

	EL_STRING_GENERAL_ROUTINES_I

	EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM; EL_MODULE_TUPLE

	EL_SHARED_PATH_MANAGER

	PLATFORM
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
	 	local
	 		n, i: INTEGER; c: NATURAL
		do
	 		create crc_table.make_filled (0, 256)
	 		from n := 0 until n = crc_table.count loop
	 			c := n.to_natural_32
	 			from i := 1 until i > 8 loop
	 				if (c & 1) /= 0 then
	 					c := (c |>> 1).bit_xor (0xEDB88320)
	 				else
	 					c := c |>> 1
	 				end
	 				i := i + 1
	 			end
	 			crc_table [n] := c
	 			n := n + 1
	 		end
		end

feature -- Access

	checksum: NATURAL

feature -- Status query

	reals_by_out: BOOLEAN
		-- when `True' type `DOUBLE' and `REAL' types are added as `STRING_8' by calling `out' function
		-- useful if checking results of representation in XML etc

feature -- Status change

	set_reals_by_out (yes: BOOLEAN)
		do
			reals_by_out := yes
		end

feature -- Add file content

	add_directory_tree (tree_path: DIR_PATH)
		-- add contents of file directory tree `tree_path'
		do
			File_system.files (tree_path, True).do_all (agent add_file)
		end

	add_file (file_path: FILE_PATH)
		-- add contents of file at `file_path'
		require
			path_exists: file_path.exists
		do
			File.do_with_all_blocks (file_path, agent add_data, File_block_size)
		end

	add_file_first (file_path: FILE_PATH; max_byte_count: INTEGER)
		-- add first `max_byte_count' bytes of content from file at `file_path'
		-- or entire file if `max_byte_count = 0'
		require
			path_exists: file_path.exists
		do
			File.do_with_blocks (file_path, agent add_data, max_byte_count, File_block_size)
		end

feature -- Add basic types

	add_boolean (b: BOOLEAN)
			--
		do
			add_to_checksum ($b, 1, Boolean_bytes)
		end

	add_character_32 (c: CHARACTER_32)
			--
		do
			add_to_checksum ($c, 1, Character_32_bytes)
		end

	add_character_8 (c: CHARACTER)
			--
		do
			add_to_checksum ($c, 1, Character_8_bytes)
		end

	add_character_data (area: SPECIAL [CHARACTER])
		do
			add_to_checksum (area.base_address, area.count, Character_8_bytes * area.count)
		end

	add_data (block: MANAGED_POINTER)
			--
		do
			add_to_checksum (block.item, block.count, 1)
		end

	add_pointer (b: POINTER)
			--
		do
			add_to_checksum ($b, 1, Pointer_bytes)
		end

	add_tuple (a_tuple: TUPLE)
		do
			Tuple.write (a_tuple, Current, Void)
		end

feature -- Add reals

	add_real_32, add_real (real: REAL)
			--
		do
			if reals_by_out then
				add_string_8 (real.out)
			else
				add_to_checksum ($real, 1, Real_32_bytes)
			end
		end

	add_real_64, add_double (real: DOUBLE)
			--
		do
			if reals_by_out then
				add_string_8 (real.out)
			else
				add_to_checksum ($real, 1, Real_64_bytes)
			end
		end

feature -- Add integers

	add_integer_16 (n: INTEGER_16)
			--
		do
			add_to_checksum ($n, 1, Integer_16_bytes)
		end

	add_integer_32, add_integer (n: INTEGER)
			--
		do
			add_to_checksum ($n, 1, Integer_32_bytes)
		end

	add_integer_64 (n: INTEGER_64)
			--
		do
			add_to_checksum ($n, 1, Integer_64_bytes)
		end

	add_integer_8 (n: INTEGER_8)
			--
		do
			add_to_checksum ($n, 1, Integer_8_bytes)
		end

feature -- Add naturals

	add_natural_16 (n: NATURAL_16)
			--
		do
			add_to_checksum ($n, 1, Natural_16_bytes)
		end

	add_natural_32, add_natural (n: NATURAL)
			--
		do
			add_to_checksum ($n, 1, Natural_32_bytes)
		end

	add_natural_64 (n: NATURAL_64)
			--
		do
			add_to_checksum ($n, 1, Natural_64_bytes)
		end

	add_natural_8 (n: NATURAL_8)
			--
		do
			add_to_checksum ($n, 1, Natural_8_bytes)
		end

feature -- Add paths

	add_ise_path (path: PATH)
			--
		do
			add_string_8 (Path_manager.storage (path))
		end

	add_path (path: EL_PATH)
			--
		do
			add_string (path.parent_string (False))
			add_string (path.base)
		end

feature -- Add strings

	add_string (str: ZSTRING)
			--
		do
			add_to_checksum (str.area.base_address, str.count, character_8_bytes)
			if str.has_mixed_encoding then
				add_to_checksum (str.unencoded_area.base_address, str.unencoded_area.count, character_32_bytes)
			end
		end

	add_string_32 (str: READABLE_STRING_32)
			--
		local
			index_lower: INTEGER
		do
			if conforms_to_zstring (str) and then attached {ZSTRING} str as z_str then
				add_string (z_str)

			elseif attached Character_area_32.get_lower (str, $index_lower) as area then
				add_to_checksum (area.base_address + index_lower, str.count, character_32_bytes)
			end
		end

	add_string_8 (str: READABLE_STRING_8)
			--
		local
			index_lower: INTEGER
		do
			if attached Character_area_8.get_lower (str, $index_lower) as area then
				add_to_checksum (area.base_address + index_lower, str.count, character_8_bytes)
			end
		end

	add_string_list (list: ITERABLE [READABLE_STRING_GENERAL])
		local
			l_str: READABLE_STRING_GENERAL
		do
			across list as str loop
				l_str := str.item
				add_string_general (l_str)
			end
		end

feature -- Element change

	reset
		do
			checksum := 0
			reals_by_out := False
		end

	set_checksum (a_checksum: NATURAL)
		do
			checksum := a_checksum
		end

feature {NONE} -- Implementation

	add_to_checksum (array_ptr: POINTER; count, item_bytes: INTEGER)
		-- add `count' items of raw memory data of size `item_bytes'
		local
			i, byte_count, index: INTEGER; c: NATURAL; byte: NATURAL_8
		do
			byte_count := count * item_bytes
			c := checksum.bit_not
			if attached crc_table as area then
				from i := 0 until i = byte_count loop
					($byte).memory_copy (array_ptr + i, natural_8_bytes)
					index := c.bit_xor (byte).to_integer_32 & 0xFF
					c := area [index].bit_xor (c |>> 8)
					i := i + 1
				end
			end
			checksum := c.bit_not
		end

feature {NONE} -- Internal attributes

	crc_table: SPECIAL [NATURAL]

feature {NONE} -- Constants

	File_block_size: INTEGER = 0x1000
		-- 4096 bytes
end
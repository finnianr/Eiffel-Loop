note
	description: "CRC32 algorithm described in [https://tools.ietf.org/rfc/rfc1952.txt IETF RFC 1952"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-23 11:12:28 GMT (Monday 23rd December 2019)"
	revision: "11"

class
	EL_CYCLIC_REDUNDANCY_CHECK_32

inherit
	MANAGED_POINTER
		rename
			count as byte_count,
			make as make_pointer
		export
			{NONE} all
		end

	STRING_HANDLER undefine copy, is_equal end

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make
		do
			is_shared := True
			set_from_pointer (Default_pointer, 0)
		end

feature -- Access

	checksum: NATURAL

feature -- Add file content

	add_directory_tree (tree_path: EL_DIR_PATH)
		-- add contents of file directory tree `tree_path'
		do
			File_system.recursive_files (tree_path).do_all (agent add_file)
		end

	add_file (file_path: EL_FILE_PATH)
		-- add contents of file at `file_path'
		require
			path_exists: file_path.exists
		do
			add_data (File_system.file_data (file_path))
		end

feature -- Add basic types

	add_boolean (b: BOOLEAN)
			--
		do
			add_memory ($b, 1, Boolean_bytes)
		end

	add_character_8 (c: CHARACTER)
			--
		do
			add_memory ($c, 1, Character_8_bytes)
		end

	add_character_32 (c: CHARACTER_32)
			--
		do
			add_memory ($c, 1, Character_32_bytes)
		end

	add_data (data: MANAGED_POINTER)
			--
		do
			add_memory (data.item, data.count, 1)
		end

	add_pointer (b: POINTER)
			--
		do
			add_memory ($b, 1, Pointer_bytes)
		end

	add_tuple (a_tuple: TUPLE)
		local
			i: INTEGER; l_reference: ANY
		do
			from i := 1 until i > a_tuple.count loop
				inspect a_tuple.item_code (i)
					when {TUPLE}.Boolean_code then
						add_boolean (a_tuple.boolean_item (i))

					when {TUPLE}.Character_8_code then
						add_character_8 (a_tuple.character_8_item (i))

					when {TUPLE}.Character_32_code then
						add_character_32 (a_tuple.character_32_item (i))

					when {TUPLE}.Integer_8_code then
						add_integer_8 (a_tuple.integer_8_item (i))

					when {TUPLE}.Integer_16_code then
						add_integer_16 (a_tuple.integer_16_item (i))

					when {TUPLE}.Integer_32_code then
						add_integer_32 (a_tuple.integer_32_item (i))

					when {TUPLE}.Integer_64_code then
						add_integer_64 (a_tuple.integer_64_item (i))

					when {TUPLE}.Natural_8_code then
						add_natural_8 (a_tuple.natural_8_item (i))

					when {TUPLE}.Natural_16_code then
						add_natural_16 (a_tuple.natural_16_item (i))

					when {TUPLE}.Natural_32_code then
						add_natural_32 (a_tuple.natural_32_item (i))

					when {TUPLE}.Natural_64_code then
						add_natural_64 (a_tuple.natural_64_item (i))

					when {TUPLE}.Real_32_code then
						add_real_32 (a_tuple.real_32_item (i))

					when {TUPLE}.Real_64_code then
						add_real_64 (a_tuple.real_64_item (i))

					when {TUPLE}.Pointer_code then
						add_pointer (a_tuple.pointer_item (i))

					when {TUPLE}.Reference_code then
						l_reference := a_tuple.reference_item (i)
						if attached {READABLE_STRING_GENERAL} l_reference as string then
							add_string_general (string)
						elseif attached {EL_PATH} l_reference as path then
							add_path (path)
						elseif attached {PATH} l_reference as ise_path then
							add_ise_path (ise_path)
						end
				else
				end
				i := i + 1
			end
		end

feature -- Add reals

	add_real_32, add_real (real: REAL)
			--
		do
			add_memory ($real, 1, Real_32_bytes)
		end

	add_real_64, add_double (real: DOUBLE)
			--
		do
			add_memory ($real, 1, Real_64_bytes)
		end

feature -- Add integers

	add_integer_8 (n: INTEGER_8)
			--
		do
			add_memory ($n, 1, Integer_8_bytes)
		end

	add_integer_16 (n: INTEGER_16)
			--
		do
			add_memory ($n, 1, Integer_16_bytes)
		end

	add_integer_32, add_integer (n: INTEGER)
			--
		do
			add_memory ($n, 1, Integer_32_bytes)
		end

	add_integer_64 (n: INTEGER_64)
			--
		do
			add_memory ($n, 1, Integer_64_bytes)
		end

feature -- Add naturals

	add_natural_8 (n: NATURAL_8)
			--
		do
			add_memory ($n, 1, Natural_8_bytes)
		end

	add_natural_16 (n: NATURAL_16)
			--
		do
			add_memory ($n, 1, Natural_16_bytes)
		end

	add_natural_32, add_natural (n: NATURAL)
			--
		do
			add_memory ($n, 1, Natural_32_bytes)
		end

	add_natural_64 (n: NATURAL_64)
			--
		do
			add_memory ($n, 1, Natural_64_bytes)
		end

feature -- Add strings

	add_path (path: EL_PATH)
			--
		do
			add_string (path.parent_path)
			add_string (path.base)
		end

	add_ise_path (path: PATH)
			--
		do
			add_data (path.native_string.managed_data)
		end

	add_string_list (list: ITERABLE [READABLE_STRING_GENERAL])
		do
			across list as str loop
				add_string_general (str.item)
			end
		end

	add_string (str: ZSTRING)
			--
		do
			add_memory (str.area.base_address, str.count, character_8_bytes)
			if str.has_mixed_encoding then
				add_memory (str.unencoded_area.base_address, str.unencoded_area.count, character_32_bytes)
			end
		end

	add_string_32 (str: STRING_32)
			--
		do
			add_memory (str.area.base_address, str.count, character_32_bytes)
		end

	add_string_8 (str: STRING)
			--
		do
			add_memory (str.area.base_address, str.count, character_8_bytes)
		end

	add_string_general (general: READABLE_STRING_GENERAL)
		do
			if attached {ZSTRING} general as str then
				add_string (str)
			elseif attached {STRING_8} general as str_8 then
				add_string_8 (str_8)
			elseif attached {STRING_32} general as str_32 then
				add_string_32 (str_32)
			end
		end

feature -- Element change

	reset
		do
			checksum := 0
		end

	set_checksum (a_checksum: NATURAL)
		do
			checksum := a_checksum
		end

feature {NONE} -- Implementation

	add_memory (array_ptr: POINTER; count, item_bytes: INTEGER)
		-- add `count' items of raw memory data of size `item_bytes'
		local
			i: INTEGER; c, index: NATURAL
			table: like CRC_table
		do
			table := CRC_table
			set_from_pointer (array_ptr, count * item_bytes)
			c := checksum.bit_not
			from i := 0 until i = byte_count loop
				index := c.bit_xor (read_natural_8 (i)) & 0xFF
				c := table.item (index.to_integer_32).bit_xor (c |>> 8)
				i := i + 1
			end
			checksum := c.bit_not
			set_from_pointer (Default_pointer, 0)
		end

feature {NONE} -- Constants

	CRC_table: SPECIAL [NATURAL]
 			--
	 	local
	 		n, i: INTEGER; c: NATURAL
	 	once
	 		create Result.make_filled (0, 256)
	 		from n := 0 until n = Result.count loop
	 			c := n.to_natural_32
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

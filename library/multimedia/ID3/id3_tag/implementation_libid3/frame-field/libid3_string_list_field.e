note
	description: "Libid3 string list field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-28 11:59:07 GMT (Tuesday 28th April 2020)"
	revision: "3"

class
	LIBID3_STRING_LIST_FIELD

inherit
	ID3_STRING_LIST_FIELD

	LIBID3_STRING_FIELD
		rename
			count as character_count
		export
			{NONE} string, set_string
		undefine
			type
		end

	STRING_HANDLER

	EL_MODULE_ITERABLE

create
	make

feature -- Access

	count: INTEGER
		do
			Result := cpp_text_item_count (self_ptr)
		end

	first: ZSTRING
		do
			Result := i_th_string (1)
		end

	i_th_string (index: INTEGER): ZSTRING
		local
			l_encoding: NATURAL_8
		do
			l_encoding := encoding
			if l_encoding = Encoding_enum.ISO_8859_1 then
				create Result.make_from_general (i_th_latin (index))

			elseif Encoding_enum.is_utf_16 (l_encoding) then
				-- A bit strange that only Big Endian decoding works
				Result := i_th_text_32 (index)

			elseif l_encoding = Encoding_enum.UTF_8 then
				create Result.make_from_utf_8 (i_th_latin (index))
			else
				create Result.make_empty

			end
		end
feature -- Element change

	set_list (a_list: ITERABLE [ZSTRING])
		local
--			str_32: STRING_32; c_ucs4_array: SPECIAL [POINTER]
--			c_strings: SPECIAL [EL_C_STRING_32]
		do
--			str_32 := once_string_32
--			create c_strings.make_empty (Iterable.count (a_list))
--			create c_ucs4_array.make_empty (finite.count)
--			across a_list as l_list loop
--				str_32.wipe_out
--				l_list.item.append_to_string_32 (str_32)
--				c_strings.extend (str_32)
--				c_ucs4_array.extend (c_strings.item (c_strings.count - 1).base_address)
--			end
--			c_call_status := c_id3_field_setstrings (self_ptr, finite.count, c_ucs4_array.base_address)
--		ensure then
--			call_succeeded: c_call_status = 0
		end

feature {NONE} -- Implementation

	i_th_latin (index: INTEGER): EL_STRING_8
		do
			Result := Utf_8; Result.wipe_out
			Result.from_c (cpp_text_item (self_ptr, index - 1))
		end

	i_th_character_count (index: INTEGER): INTEGER
			--
		local
			n: NATURAL_16; ptr: POINTER
		do
			ptr := cpp_unicode_text_item (self_ptr, index - 1)
			from n := 1 until n = 0 loop
				ptr.memory_copy ($n, 2)
				if n > 0 then
					Result := Result + 1
				end
				ptr := ptr + 2
			end
		end

	i_th_text_32 (index: INTEGER): STRING_32
		local
			data: like Unicode_buffer
		do
			Result := empty_once_string_32
			data := Unicode_buffer
			data.set_from_pointer (cpp_unicode_text_item (self_ptr, index - 1), i_th_character_count (index) * 2 + 2)
			UTF.utf_16_be_0_pointer_into_string_32 (data, Result)
		end

end

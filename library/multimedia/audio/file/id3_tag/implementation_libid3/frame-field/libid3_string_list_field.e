note
	description: "Summary description for {LIBID3_STRING_LIST_FIELD}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LIBID3_STRING_LIST_FIELD

inherit
	ID3_STRING_LIST_FIELD

	LIBID3_STRING_FIELD
		export
			{NONE} string, set_string
		undefine
			type
		end

	STRING_HANDLER

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
			l_encoding: INTEGER
		do
			l_encoding := encoding
			if l_encoding = Encoding_enum.ISO_8859_1 then
				create Result.make_from_general (i_th_latin (index))

			elseif l_encoding = Encoding_enum.UTF_16 or l_encoding = Encoding_enum.UTF_16_BE then
				-- A bit strange that only Big Endian decoding works
				Result := i_th_utf_16_be (index).as_string

			elseif l_encoding = Encoding_enum.UTF_8 then
				create Result.make_from_utf_8 (i_th_latin (index))
			else
				create Result.make_empty

			end
		end
feature -- Element change

	set_list (a_list: ITERABLE [ZSTRING])
		local
			str_32: STRING_32; c_ucs4_array: SPECIAL [POINTER]
			c_strings: SPECIAL [EL_C_STRING_32]
		do
--			str_32 := once_string_32
--			if attached {FINITE [ZSTRING]} a_list as finite then
--				create c_strings.make_empty (finite.count)
--				create c_ucs4_array.make_empty (finite.count)
--				across a_list as l_list loop
--					str_32.wipe_out
--					l_list.item.append_to_string_32 (str_32)
--					c_strings.extend (str_32)
--					c_ucs4_array.extend (c_strings.item (c_strings.count - 1).base_address)
--				end
--				c_call_status := c_id3_field_setstrings (self_ptr, finite.count, c_ucs4_array.base_address)
--			end
--		ensure then
--			call_succeeded: c_call_status = 0
		end

feature {NONE} -- Implementation

	i_th_latin (index: INTEGER): EL_STRING_8
		do
			Result := Utf_8; Result.wipe_out
			Result.from_c (cpp_text_item (self_ptr, index - 1))
		end

	i_th_utf_16_be (index: INTEGER): EL_C_STRING_16_BE
			--
		do
			create Result.make_shared (cpp_unicode_text_item (self_ptr, index - 1))
		end

end

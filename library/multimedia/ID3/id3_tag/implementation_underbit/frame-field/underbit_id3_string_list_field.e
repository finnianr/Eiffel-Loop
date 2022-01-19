note
	description: "Underbit id3 string list field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-19 10:11:53 GMT (Wednesday 19th January 2022)"
	revision: "3"

class
	UNDERBIT_ID3_STRING_LIST_FIELD

inherit
	ID3_STRING_LIST_FIELD

	UNDERBIT_ID3_FRAME_FIELD
		rename
			make as make_from_pointer
		end

	UNDERBIT_ID3_STRING_ROUTINES

	STRING_HANDLER

	EL_MODULE_ITERABLE

	EL_MODULE_REUSABLE

create
	make

feature -- Access

	count: INTEGER
		do
			Result := c_id3_field_getnstrings (self_ptr)
		end

	i_th_string (index: INTEGER): ZSTRING
		do
			Result := string_at_address (c_id3_field_getstrings (self_ptr, index - 1))
		end

	first: ZSTRING
		do
			Result := string_at_address (c_id3_field_getstrings (self_ptr, 0))
		end

feature -- Element change

	set_encoding (new_encoding: NATURAL_8)
		do
		end

	set_list (a_list: ITERABLE [ZSTRING])
		local
			str_32: STRING_32; c_ucs4_array: SPECIAL [POINTER]
			c_strings: SPECIAL [EL_C_STRING_32]; list_count: INTEGER
		do
			list_count := Iterable.count (a_list)
			create c_strings.make_empty (list_count)
			create c_ucs4_array.make_empty (list_count)
			across Reuseable.string_32 as reuse loop
				str_32 := reuse.item
				across a_list as l_list loop
					str_32.wipe_out
					l_list.item.append_to_string_32 (str_32)
					c_strings.extend (str_32)
					c_ucs4_array.extend (c_strings.item (c_strings.count - 1).base_address)
				end
			end
			c_call_status := c_id3_field_setstrings (self_ptr, list_count, c_ucs4_array.base_address)
		ensure then
			call_succeeded: c_call_status = 0
		end

feature {NONE} -- Constant

	Underbit_type: INTEGER
		once
			Result := field_type_list_string
		end

end
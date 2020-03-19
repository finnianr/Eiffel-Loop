note
	description: "User text identification frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-19 16:52:12 GMT (Thursday 19th March 2020)"
	revision: "1"

class
	TL_USER_TEXT_IDENTIFICATION_ID3_FRAME

inherit
	TL_TEXT_ID3_FRAME
		rename
			field_list as text_list
		redefine
			text_list, set_text
		end

	TL_USER_TEXT_IDENTIFICATION_ID3_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_conforms
		end

	TL_SHARED_STRING_ENCODING_ENUM

create
	make, make_from_pointer

feature {NONE} -- Initialization

	make (a_description: READABLE_STRING_GENERAL; values: ITERABLE [READABLE_STRING_GENERAL]; encoding: NATURAL_8)
		require
			valid_encoding: valid_encoding (encoding)
		local
			list: like Once_string_list
		do
			Once_string.set_from_string (a_description)
			list := Once_string_list
			list.wipe_out; list.append (values)
			make_from_pointer (cpp_new (Once_string.self_ptr, list.self_ptr, encoding))
		ensure
			description_set: a_description.same_string (description)
		end

feature -- Access

	description: ZSTRING
		do
			cpp_get_description (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

	text_list: EL_ZSTRING_LIST
		-- `field_list' with `description' removed from head
		do
			Result := Precursor
			if not Result.is_empty then
				Result.remove_head (1)
			end
		end

feature -- Element change

	set_text (a_text: READABLE_STRING_GENERAL)
		local
			list: like Once_string_list
		do
			list := Once_string_list
			list.wipe_out
			if a_text.has ('%N') then
				list.append (a_text.split ('%N'))
			else
				list.extend (a_text)
			end
			cpp_set_text_from_list (self_ptr, list.self_ptr)
		ensure then
			set: text_list ~ (create {EL_ZSTRING_LIST}.make_with_lines (a_text))
		end
end

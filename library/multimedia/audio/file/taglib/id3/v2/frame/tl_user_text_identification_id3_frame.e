note
	description: "User text identification frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-26 12:33:49 GMT (Thursday 26th March 2020)"
	revision: "6"

class
	TL_USER_TEXT_IDENTIFICATION_ID3_FRAME

inherit
	TL_TEXT_IDENTIFICATION_ID3_FRAME
		rename
			make as make_frame,
			field_list as text_list
		redefine
			text_list, set_text
		end

	TL_DESCRIBEABLE_ID3_TAG_FRAME
		rename
			cpp_get_description as cpp_user_get_description,
			cpp_set_description as cpp_user_set_description
		redefine
			set_text
		end

	TL_USER_TEXT_IDENTIFICATION_ID3_FRAME_CPP_API
		export
			{TL_ID3_FRAME_ITERATION_CURSOR} cpp_user_conforms
		end

	TL_SHARED_STRING_ENCODING_ENUM

create
	make, make_from_pointer

feature {NONE} -- Initialization

	make (a_description: READABLE_STRING_GENERAL; values: ITERABLE [READABLE_STRING_GENERAL]; a_encoding: NATURAL_8)
		require
			valid_encoding: valid_encoding (a_encoding)
		local
			list: like Once_string_list
		do
			Once_string_2.set_from_string (a_description)
			list := Once_string_list
			list.wipe_out; list.append (values)
			make_from_pointer (cpp_user_new (Once_string_2.self_ptr, list.self_ptr, a_encoding))
		ensure
			description_set: a_description.same_string (description)
		end

feature -- Access

	text_list: EL_ZSTRING_LIST
		-- `field_list' with `description' removed from head
		do
			Once_string_list.replace_all (cpp_user_field_list (self_ptr))
			Result := Once_string_list.to_list
			if not Result.is_empty then
				Result.remove_head (1)
			end
		end

feature {TL_ID3_V2_TAG_FRAME_ROUTINES} -- Implementation

	fill (a_text_list: EL_ZSTRING_LIST)
		local
			not_first: BOOLEAN
		do
			Once_string_list.replace_all (cpp_user_field_list (self_ptr))
			across Once_string_list as string loop
				if not_first then
					a_text_list.extend (string.item)
				else
					not_first := True
				end
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
			cpp_user_set_text_from_list (self_ptr, list.self_ptr)
		ensure then
			set: text_list ~ (create {EL_ZSTRING_LIST}.make_with_lines (a_text))
		end
end

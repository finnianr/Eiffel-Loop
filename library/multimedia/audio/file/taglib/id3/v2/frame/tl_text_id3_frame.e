note
	description: "Tl text id3 frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-19 12:51:57 GMT (Thursday 19th March 2020)"
	revision: "1"

deferred class
	TL_TEXT_ID3_FRAME

inherit
	TL_ID3_TAG_FRAME

feature -- Access

	field_list: EL_ZSTRING_LIST
		do
			Once_string_list.replace_all (cpp_field_list (self_ptr))
			Result := Once_string_list.to_list
		end
		
feature {NONE} -- Implementation

	cpp_field_list (self: POINTER): POINTER
		deferred
		end

end

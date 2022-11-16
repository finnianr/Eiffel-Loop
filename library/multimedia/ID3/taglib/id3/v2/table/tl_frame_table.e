note
	key: "Summary key for {TL_FRAME_FINDER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	TL_FRAME_TABLE [F -> TL_ID3_TAG_FRAME create make_from_pointer end]

inherit
	EL_C_API_ROUTINES

	TL_SHARED_ONCE_STRING

feature -- Access

	found_item: F

feature -- Status query

	has (tag_ptr: POINTER; key: READABLE_STRING_GENERAL): BOOLEAN
		do
			Once_string.set_from_string (key)
			Result := is_attached (cpp_find_frame (tag_ptr, Once_string.self_ptr))
		end

	has_key (tag_ptr: POINTER; key: READABLE_STRING_GENERAL): BOOLEAN
		local
			frame_ptr: POINTER
		do
			Once_string.set_from_string (key)
			frame_ptr := cpp_find_frame (tag_ptr, Once_string.self_ptr)
			if is_attached (frame_ptr) then
				create found_item.make_from_pointer (frame_ptr)
				Result := True
			end
		end

feature {NONE} -- Implementation

	cpp_find_frame (tag_ptr, key: POINTER): POINTER
		deferred
		end

end
note
	key: "Summary key for {TL_FRAME_FINDER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 13:57:33 GMT (Saturday 21st March 2020)"
	revision: "1"

deferred class
	TL_FRAME_TABLE [F -> TL_ID3_TAG_FRAME create make_from_pointer end]

inherit
	EL_POINTER_ROUTINES

	TL_SHARED_ONCE_STRING

feature -- Access

	found_item: F

feature -- Status query

	has (tag: TL_ID3_V2_TAG; key: READABLE_STRING_GENERAL): BOOLEAN
		do
			Once_string.set_from_string (key)
			Result := is_attached (cpp_find_frame (tag.self_ptr, Once_string.self_ptr))
		end

	has_key (tag: TL_ID3_V2_TAG; key: READABLE_STRING_GENERAL): BOOLEAN
		local
			frame_ptr: POINTER
		do
			Once_string.set_from_string (key)
			frame_ptr := cpp_find_frame (tag.self_ptr, Once_string.self_ptr)
			if is_attached (frame_ptr) then
				create found_item.make_from_pointer (frame_ptr)
				Result := True
			end
		end

feature {NONE} -- Implementation

	cpp_find_frame (tag, key: POINTER): POINTER
		deferred
		end

end

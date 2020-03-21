note
	description: "Tl describeable id3 tag frame"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-21 19:25:22 GMT (Saturday 21st March 2020)"
	revision: "1"

deferred class
	TL_DESCRIBEABLE_ID3_TAG_FRAME

inherit
	TL_ID3_TAG_FRAME

feature -- Access

	description: ZSTRING
		do
			cpp_get_description (self_ptr, Once_string.self_ptr)
			Result := Once_string.to_string
		end

feature -- Element change

	set_description (a_description: READABLE_STRING_GENERAL)
		do
			Once_string.set_from_string (a_description)
			cpp_set_description (self_ptr, Once_string.self_ptr)
		ensure
			set: description.same_string (a_description)
		end

feature {NONE} -- Implementation

	cpp_get_description (self, string: POINTER)
		deferred
		end

	cpp_set_description (self, string: POINTER)
		deferred
		end
end

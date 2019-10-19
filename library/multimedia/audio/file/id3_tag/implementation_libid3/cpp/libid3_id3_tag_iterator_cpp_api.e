note
	description: "Interface to class ID3_Tag::Iterator"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LIBID3_ID3_TAG_ITERATOR_CPP_API

inherit
	LIBID3_CPP_API

feature {NONE} -- Externals

	cpp_delete (self: POINTER)
			--
		external
			"C++ [delete ID3_Tag::Iterator %"id3/tag.h%"] ()"
		end

	cpp_iterator_next (iterator: POINTER): POINTER
			--
		external
			"C++ [ID3_Tag::Iterator %"id3/tag.h%"]: EIF_POINTER ()"
		alias
			"GetNext"
		end
end

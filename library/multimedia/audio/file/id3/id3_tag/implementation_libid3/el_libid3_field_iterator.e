note
	description: "Summary description for {EL_LIBID3_FIELD_ITERATOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_LIBID3_FIELD_ITERATOR

inherit
	EL_CPP_ITERATOR [EL_LIBID3_FIELD]
		redefine
			create_item
		end

	EL_ID3_FIELD_TYPES
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Implementation

	create_item: EL_LIBID3_FIELD
		do
			create Result.make_from_pointer (cpp_item)
			if Result.type = Type_encoding then
				create {EL_LIBID3_ENCODING_FIELD} Result.make_from_pointer (cpp_item)
			end
		end

feature {NONE} -- Externals

    cpp_delete (self: POINTER)
            --
        external
            "C++ [delete ID3_Frame::Iterator %"id3/tag.h%"] ()"
        end

    cpp_iterator_next (iterator: POINTER): POINTER
            --
        external
            "C++ [ID3_Frame::Iterator %"id3/tag.h%"]: EIF_POINTER ()"
        alias
        	"GetNext"
        end

end

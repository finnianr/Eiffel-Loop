note
	description: "Summary description for {EL_LIBID3_FIELD_ITERATOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "4"

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

note
	description: "Summary description for {EL_C_STRING_8_LE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EL_C_STRING_8_LE

inherit
	EL_C_STRING_8
		redefine
			item, put_item
		end

create
	make_owned, make_shared, make_owned_of_size, make_shared_of_size, make, make_from_string

feature -- Access

	item (index: INTEGER): NATURAL_32
			--
		do
			Result := read_natural_8_le ((index - 1) * width)
		end

feature -- Element change	

	put_item (value: NATURAL_32; index: INTEGER)
			--
		do
			put_natural_8_le (value.to_natural_8, (index - 1) * width)
		end

end

note
	description: "Summary description for {EL_C_STRING_16_BE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-30 14:10:27 GMT (Wednesday 30th October 2013)"
	revision: "2"

class
	EL_C_STRING_16_BE

inherit
	EL_C_STRING_16
		redefine
			item, put_item
		end

create
	default_create, make_owned, make_shared, make_owned_of_size, make_shared_of_size, make, make_from_string

feature -- Access

	item (index: INTEGER): NATURAL_32
			--
		do
			Result := read_natural_16_be ((index - 1) * width)
		end

feature -- Element change	

	put_item (value: NATURAL_32; index: INTEGER)
			--
		do
			put_natural_16_be (value.to_natural_16, (index - 1) * width)
		end

end

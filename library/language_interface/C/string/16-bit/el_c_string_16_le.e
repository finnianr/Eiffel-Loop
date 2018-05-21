note
	description: "C string 16 le"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:21 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_C_STRING_16_LE

inherit
	EL_C_STRING_16
		redefine
			item, put_item
		end

create
	make_owned, make_shared, make_owned_of_size, make_shared_of_size, make, make_from_string

feature -- Access

	item (index: INTEGER): NATURAL_32
			--
		do
			Result := read_natural_16_le ((index - 1) * width)
		end

feature -- Element change	

	put_item (value: NATURAL_32; index: INTEGER)
			--
		do
			put_natural_16_le (value.to_natural_16, (index - 1) * width)
		end

end
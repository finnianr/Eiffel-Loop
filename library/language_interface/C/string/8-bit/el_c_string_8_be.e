note
	description: "Summary description for {EL_C_STRING_8_BE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_C_STRING_8_BE

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
			Result := read_natural_8_be ((index - 1) * width)
		end

feature -- Element change	

	put_item (value: NATURAL_32; index: INTEGER)
			--
		do
			put_natural_8_be (value.to_natural_8, (index - 1) * width)
		end

end
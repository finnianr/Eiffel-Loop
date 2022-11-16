note
	description: "C string 32 be"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_C_STRING_32_BE

inherit
	EL_C_STRING_32
		redefine
			item, put_item
		end

create
	make_owned, make_shared, make_owned_of_size, make_shared_of_size, make, make_from_string

feature -- Access

	item (index: INTEGER): NATURAL_32
			--
		do
			Result := read_natural_32_be ((index - 1) * width)
		end

feature -- Element change	

	put_item (value: NATURAL_32; index: INTEGER)
			--
		do
			put_natural_32_be (value, (index - 1) * width)
		end

end
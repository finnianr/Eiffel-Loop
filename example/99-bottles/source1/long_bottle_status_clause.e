indexing
	description: "Summary description for {LONG_BOTTLE_STATUS_CLAUSE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	LONG_BOTTLE_STATUS_CLAUSE

inherit
	BOTTLE_STATUS_CLAUSE
		redefine
			make
		end

create
	make

convert
	make ({INTEGER})

feature {NONE} -- Initialization

	make (quantity: INTEGER) is

		do
			Precursor (quantity)
			append_string ("on the wall")
		end

end -- class LONG_BOTTLE_STATUS_CLAUSE

note
	description: "Summary description for {COUNTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 12:35:45 GMT (Wednesday 16th December 2015)"
	revision: "4"

class
	COUNTRY

inherit
	EL_TABLE_LINKED

create
	make

feature -- Access

	code: STRING

	name: ZSTRING

	population: INTEGER

	literacy_rate: REAL

	data_1: NATURAL_32
			-- First data segment

	data_2: NATURAL_16
			-- Second data segment

	data_3: NATURAL_16
			-- Third data segment

	data_4: NATURAL_16
			-- Fourth data segment

	data_5: NATURAL_64
			-- Fifth and final data segment

end

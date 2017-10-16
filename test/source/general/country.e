note
	description: "Summary description for {COUNTRY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:02 GMT (Thursday 12th October 2017)"
	revision: "2"

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
note
	description: "Summary description for {COUNTRY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COUNTRY

inherit
	EL_TABLE_LINKED

create
	make

feature -- Access

	code: STRING

	name: ASTRING

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

note
	description: "Summary description for {EL_HTTP_PARAMETER_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_HTTP_PARAMETER_LIST [P -> EL_HTTP_PARAMETER]

inherit
	EL_ARRAYED_LIST [P]

	EL_HTTP_PARAMETER
		rename
			extend as extend_table
		undefine
			is_equal, copy
		end

create
	make, make_from_array

convert
	make_from_array ({ARRAY [P]})


feature -- Conversion

	to_table: EL_HTTP_HASH_TABLE
		do
			create Result.make_equal (count)
			extend_table (Result)
		end

feature {NONE} -- Implementation

	extend_table (table: EL_HTTP_HASH_TABLE)
		do
			from start until after loop
				item.extend (table)
				forth
			end
		end

end

note
	description: "Summary description for {EL_HTTP_PARAMETER_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-02 12:25:22 GMT (Friday 2nd March 2018)"
	revision: "4"

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

	to_table: EL_URL_QUERY_HASH_TABLE
		do
			create Result.make_equal (count)
			extend_table (Result)
		end

feature {NONE} -- Implementation

	extend_table (table: like to_table)
		do
			from start until after loop
				item.extend (table)
				forth
			end
		end

end

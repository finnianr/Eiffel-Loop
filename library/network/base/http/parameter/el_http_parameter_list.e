note
	description: "HTTP parameter list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-13 13:29:02 GMT (Friday 13th April 2018)"
	revision: "5"

class
	EL_HTTP_PARAMETER_LIST [P -> EL_HTTP_PARAMETER]

inherit
	EL_ARRAYED_LIST [P]
		rename
			make as make_size,
			make_from_array as make
		end

	EL_HTTP_PARAMETER
		rename
			extend as extend_table
		undefine
			is_equal, copy
		end

create
	make_size, make

convert
	make ({ARRAY [P]})

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

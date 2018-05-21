note
	description: "Evolicity variable reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EVOLICITY_VARIABLE_REFERENCE

inherit
	EL_ZSTRING_LIST
		rename
			item as step,
			islast as is_last_step,
			last as last_step
		redefine
			out
		end

create
	make_empty, make, make_from_array

feature -- Access

	out: STRING
		do
			Result := joined ('.').to_latin_1
		end

	arguments: ARRAY [ANY]
			-- Arguments for eiffel context function with open arguments
		do
			Result := Empty_arguments
		end

feature -- Status query

	before_last: BOOLEAN
		do
			Result := index = count - 1
		end

feature {NONE} -- Constants

	Empty_arguments: ARRAY [ANY]
		once
			create Result.make_empty
		end
end
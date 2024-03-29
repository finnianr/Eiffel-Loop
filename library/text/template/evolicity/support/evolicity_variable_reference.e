note
	description: "Evolicity variable reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EVOLICITY_VARIABLE_REFERENCE

inherit
	EL_STRING_8_LIST
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
			Result := joined ('.')
		end

	arguments: TUPLE
			-- Arguments for eiffel context function with open arguments
		do
			Result := Default_arguments
		end

feature {NONE} -- Constants

	Default_arguments: TUPLE
		once
			create Result
		end
end
note
	description: "Evolicity variable reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-13 18:27:19 GMT (Thursday 13th March 2025)"
	revision: "9"

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

	arguments: like Default_arguments
			-- Arguments for eiffel context function with open arguments
		do
			Result := Default_arguments
		end

feature {NONE} -- Constants

	Default_arguments: EL_ARRAYED_LIST [ANY]
		once
			create Result.make (0)
		end
end
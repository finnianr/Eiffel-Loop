note
	description: "Evolicity function reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EVOLICITY_FUNCTION_REFERENCE

inherit
	EVOLICITY_VARIABLE_REFERENCE
		rename
			make as make_reference
		redefine
			arguments
		end

create
	make

feature {NONE} -- Initialization

	make (a_variable_ref_steps: ARRAY [ZSTRING]; a_arguments: like arguments)
		do
			make_from_array (a_variable_ref_steps)
			arguments := a_arguments
		end

feature -- Access

	arguments: ARRAY [ANY]
		-- Arguments for eiffel context function with open arguments

end
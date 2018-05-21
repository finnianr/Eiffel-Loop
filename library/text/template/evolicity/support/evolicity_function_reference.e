note
	description: "Evolicity function reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

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
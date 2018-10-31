note
	description: "Evolicity function reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-30 11:38:32 GMT (Tuesday 30th October 2018)"
	revision: "5"

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

	make (a_variable_ref_steps: ARRAY [STRING]; a_arguments: TUPLE)
		do
			make_from_array (a_variable_ref_steps)
			arguments := a_arguments
		end

feature -- Access

	arguments: TUPLE
		-- Arguments for eiffel context function with open arguments

end

note
	description: "Evolicity function reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EVOLICITY_FUNCTION_REFERENCE

inherit
	EVOLICITY_VARIABLE_REFERENCE
		rename
			make as make_sized
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
note
	description: "Summary description for {EVOLICITY_FUNCTION_REFERENCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	make (a_variable_ref_steps: ARRAY [EL_ASTRING]; a_arguments: like arguments)
		do
			make_from_array (a_variable_ref_steps)
			arguments := a_arguments
		end

feature -- Access

	arguments: ARRAY [ANY]
		-- Arguments for eiffel context function with open arguments

end

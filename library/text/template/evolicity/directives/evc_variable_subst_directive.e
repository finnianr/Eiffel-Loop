note
	description: "Evolicity variable substitution directive"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:04:25 GMT (Tuesday 18th March 2025)"
	revision: "13"

class
	EVC_VARIABLE_SUBST_DIRECTIVE

inherit
	EVC_DIRECTIVE

create
	make

feature {NONE} -- Initialization

	make (a_variable_path: like variable_path)
			--
		do
			variable_path := a_variable_path
		end

feature -- Basic operations

	execute (context: EVC_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		do
			if attached context.referenced_item (variable_path) as item then
				output.put_any (item)
			else
				output.put_string (variable_path.canonical)
			end
		end

feature {NONE} -- Internal attributes

	variable_path: EVC_VARIABLE_REFERENCE

end
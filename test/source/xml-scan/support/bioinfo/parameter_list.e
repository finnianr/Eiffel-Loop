note
	description: "Parameter list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:10:04 GMT (Sunday 22nd September 2024)"
	revision: "9"

class
	PARAMETER_LIST

inherit
	ARRAYED_LIST [PARAMETER]
		redefine
			make
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		undefine
			is_equal, copy
		redefine
			building_action_table, on_context_return
		end

create
	make

feature {NONE} -- Initialization

	make (n: INTEGER)
			--
		do
			Precursor (n)
			make_default
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to element: parlist
		do
			create Result.make_assignments (<<
				["par", agent do set_next_context (create {PARAMETER}.make) end]
			>>)
		end

feature {NONE} -- Implementation

	on_context_return (context: EL_EIF_OBJ_XPATH_CONTEXT)
			--
		do
			if attached {PARAMETER} context as parameter then
				extend (parameter.merged_descendant)
			end
		end

end
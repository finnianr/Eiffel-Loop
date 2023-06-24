note
	description: "Parameter list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 14:44:31 GMT (Saturday 24th June 2023)"
	revision: "7"

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
			create Result.make (<<
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
note
	description: "Parameter list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-18 12:42:29 GMT (Friday 18th January 2019)"
	revision: "5"

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

	create_new_parameter_for_next_context
			--
		do
			set_next_context (create {PARAMETER}.make)
		end

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to element: parlist
		do
			create Result.make (<<
				["par", agent create_new_parameter_for_next_context]
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

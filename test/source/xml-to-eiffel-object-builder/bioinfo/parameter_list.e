note
	description: "Summary description for {PARAMETER_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:22 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	PARAMETER_LIST

inherit
	ARRAYED_LIST [PARAMETER]
		redefine
			make
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make as make_builder
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
			make_builder
		end

feature {NONE} -- Build from XML

	create_new_parameter_for_next_context
			--
		do
			set_next_context (create {PARAMETER}.make)
		end

	building_action_table: like Type_building_actions
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

note
	description: "Summary description for {BIOINFO_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:22 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	BIOINFO_COMMAND

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		redefine
			default_create, building_action_table
		end

	EL_MODULE_LOG
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	default_create
			--
		do
			create parameter_list.make (10)
		end

feature -- Access

	id: STRING

	menu: STRING

	parameter_list: PARAMETER_LIST

feature -- Basic operations

	display
			--
		do
			log.enter ("display")
			log.put_string_field ("id", id)
			log.put_new_line
			log.put_string_field ("menu", menu)
			log.put_new_line

			from parameter_list.start until parameter_list.after loop
				parameter_list.item.display
				parameter_list.forth
			end
			log.exit
		end

feature {NONE} -- Build from XML

	set_id_from_node
			--
		do
			id := node.to_string
		end

	set_menu_from_node
			--
		do
			menu := node.to_string
		end

	build_parameter_list
			--
		do
			set_next_context (parameter_list)
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to element: command
		do
			-- Call precursor to include xmlns attribute
			create Result.make (<<
				["id/text()", agent set_id_from_node],
				["menu/text()", agent set_menu_from_node],
				["parlist", agent build_parameter_list]
			>>)
		end

end

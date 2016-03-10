note
	description: "Summary description for {DATA_PARAMETER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-15 8:54:58 GMT (Tuesday 15th December 2015)"
	revision: "4"

class
	DATA_PARAMETER

inherit
	PARAMETER
		redefine
			default_create, building_action_table, display_item
		end

create
	make

feature {NONE} -- Initialization

	default_create
			--
		do
			Precursor {PARAMETER}
			create flow.make_empty
			create type.make_empty
			create flavor.make_empty
			create flavor.make_empty
		end

feature -- Access

	flow: STRING

	type: STRING

	flavor: STRING

	filename: STRING

feature {NONE} -- Implementation

	display_item
			--
		do
			log.put_new_line
			log.put_string_field ("flow", flow)
			log.put_string_field (" type", type)
			log.put_string_field (" flavor", flavor)
			log.put_string_field (" filename", filename)
			log.put_new_line
		end

feature {NONE} -- Build from XML

	set_flow_from_node
			--
		do
			flow := node.to_string
		end

	set_type_from_node
			--
		do
			type := node.to_string
		end

	set_flavor_from_node
			--
		do
			flavor := node.to_string
		end

	set_filename_from_node
			--
		do
			filename := node.to_string
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to element: value
		do
			create Result.make (<<
				["dataflow/text()", agent set_flow_from_node],
				["datatype/text()", agent set_type_from_node],
				["flavor/text()", agent set_flavor_from_node],
				["filename/text()", agent set_filename_from_node]
			>>)
		end

end

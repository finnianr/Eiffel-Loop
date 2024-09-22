note
	description: "Data parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:16:46 GMT (Sunday 22nd September 2024)"
	revision: "8"

class
	DATA_PARAMETER

inherit
	PARAMETER
		redefine
			make, building_action_table, display_item
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor {PARAMETER}
			create flow.make_empty
			create type.make_empty
			create flavor.make_empty
			create filename.make_empty
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

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to element: value
		do
			create Result.make_assignments (<<
				["dataflow/text()", agent do node.set_8 (flow) end],
				["datatype/text()", agent do node.set_8 (type) end],
				["flavor/text()", agent do node.set_8 (flavor) end],
				["filename/text()", agent do node.set_8 (filename) end]
			>>)
		end

end
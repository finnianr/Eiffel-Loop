note
	description: "Procedure execution acknowlegement"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:03:12 GMT (Monday 24th June 2013)"
	revision: "2"

class
	EL_EROS_PROCEDURE_STATUS

inherit
	EL_BUILDABLE_XML_FILE_PERSISTENT
		redefine
			building_action_table
		end

create
	make

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result
		end

feature {NONE} -- Building from XML

	building_action_table: like Type_building_actions
			--
		do
			create Result
		end

	Root_node_name: STRING = "procedure-executed"

feature -- Constants

	Template: STRING =
		--
	"[
		<?xml version="1.0" encoding="iso-8859-1"?>
		<?create EL_EROS_PROCEDURE_STATUS?>
		<procedure-executed/>
	]"

end

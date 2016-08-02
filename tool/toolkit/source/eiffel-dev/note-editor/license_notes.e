note
	description: "Summary description for {LICENSE_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 11:06:22 GMT (Friday 18th December 2015)"
	revision: "1"

class
	LICENSE_NOTES

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default, building_action_table
		end

	EL_MODULE_LOG

create
	make_default, make_from_file, make_from_string

feature {NONE} -- Initialization

	make_default
		do
			create author.make_empty
			create copyright.make_empty
			create contact.make_empty
			create license.make_empty
			Precursor
		end

feature -- Access

	author: ZSTRING

	copyright: ZSTRING

	contact: ZSTRING

	license: ZSTRING

feature {NONE} -- Build from XML

	building_action_table: like Type_building_actions
			-- Nodes relative to root element: bix
		do
			create Result.make (<<
				["@author", 	agent do author := node.to_string end],
				["@copyright", agent do copyright := node.to_string end],
				["@contact",	agent do contact := node.to_string end],
				["@license", 	agent do license := node.to_string end]
			>>)
		end

	Root_node_name: STRING = "notes"

end
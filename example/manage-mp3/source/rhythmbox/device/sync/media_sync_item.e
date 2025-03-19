note
	description: "Media sync item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:00:33 GMT (Tuesday 18th March 2025)"
	revision: "10"

class
	MEDIA_SYNC_ITEM

inherit
	EVC_EIFFEL_CONTEXT
		redefine
			getter_function_table
		end

	EL_MODULE_XML

create
	make, make_from_xpath_context

feature {NONE} -- Initialization

	make (a_id: like id; a_checksum: like checksum; a_file_relative_path: like relative_file_path)
		do
			make_default
			id := a_id; checksum := a_checksum; relative_file_path := a_file_relative_path
		end

	make_from_xpath_context (a_id: like id; item_node: EL_XPATH_NODE_CONTEXT)
			--
		do
			make (a_id, item_node.query (Xpath_checksum).as_natural, item_node.query (Xpath_location))
		end

feature -- Access

	checksum: NATURAL

	id: STRING

	relative_file_path: FILE_PATH
		-- volume file path

feature -- Element change

	set_id (a_id: like id)
		do
			id := a_id
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["file_relative_path", agent: ZSTRING do Result := XML.escaped (relative_file_path) end],
				["checksum",			  agent: NATURAL_32_REF do Result := checksum.to_reference end],
				["id",					  agent: STRING do Result := id.out end]
			>>)
		end

feature {NONE} -- Constants

	Xpath_checksum: STRING_32 = "checksum/text()"

	Xpath_location: STRING_32 = "location/text()"

end
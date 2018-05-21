note
	description: "Media sync item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:19 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	MEDIA_SYNC_ITEM

inherit
	EVOLICITY_EIFFEL_CONTEXT
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
			make (a_id, item_node.natural_at_xpath (Xpath_checksum), item_node.string_32_at_xpath (Xpath_location))
		end

feature -- Access

	checksum: NATURAL

	id: EL_UUID

	relative_file_path: EL_FILE_PATH
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
			create Result.make (<<
				["file_relative_path", agent: ZSTRING do Result := XML.escaped (relative_file_path) end],
				["checksum", agent: NATURAL_32_REF do Result := checksum.to_reference end],
				["id", agent: STRING do Result := id.out end]
			>>)
		end

feature {NONE} -- Constants

	Xpath_checksum: STRING_32 = "checksum/text()"

	Xpath_location: STRING_32 = "location/text()"

end
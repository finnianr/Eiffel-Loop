note
	description: "Summary description for {RBOX_SYNC_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:19:29 GMT (Monday 24th June 2013)"
	revision: "2"

class
	RBOX_SYNC_INFO

inherit
	EVOLICITY_EIFFEL_CONTEXT
		redefine
			getter_function_table
		end

	EL_MODULE_STRING

	EL_MODULE_XML

create
	make, make_from_xpath_context

feature {NONE} -- Initialization

	make_from_xpath_context (a_id: like id; song_node: EL_XPATH_NODE_CONTEXT)
			--
		do
			make (a_id, song_node.natural_at_xpath ("checksum/text()"), song_node.string_32_at_xpath ("location/text()"))
		end

	make (a_id: like id; a_checksum: like checksum; a_file_relative_path: like file_relative_path)
		do
			make_eiffel_context
			id := a_id; checksum := a_checksum; file_relative_path := a_file_relative_path
		end

feature -- Access

	file_relative_path: EL_FILE_PATH

	checksum: NATURAL

	id: NATURAL_64

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
				["file_relative_path", agent: EL_ASTRING do Result := XML.basic_escaped (file_relative_path) end],
				["checksum", agent: NATURAL_32_REF do Result := checksum.to_reference end],
				["id", agent: STRING do Result := id.to_hex_string end]
			>>)
		end

end

note
	description: "Summary description for {RBOX_SYNC_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-06 17:22:05 GMT (Sunday 6th October 2013)"
	revision: "3"

class
	EXPORTED_SONG_INFO

inherit
	EVOLICITY_EIFFEL_CONTEXT
		redefine
			getter_function_table
		end

	EL_MODULE_STRING

	EL_MODULE_XML

create
	make, make_from_song, make_from_xpath_context

convert
	make_from_song ({RBOX_SONG})

feature {NONE} -- Initialization

	make_from_xpath_context (a_id: like id; song_node: EL_XPATH_NODE_CONTEXT)
			--
		do
			make (a_id, song_node.natural_at_xpath ("checksum/text()"), song_node.string_32_at_xpath ("location/text()"))
		end

	make (a_id: like id; a_checksum: like checksum; a_file_relative_path: like relative_file_path)
		do
			make_default
			id := a_id; checksum := a_checksum; relative_file_path := a_file_relative_path
		end

	make_from_song (song: RBOX_SONG)

		do
			make (song.track_id, song.last_checksum, song.mp3_relative_path)
		end

feature -- Access

	relative_file_path: EL_FILE_PATH
		-- volume file path

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
				["file_relative_path", agent: ASTRING do Result := XML.escaped (relative_file_path) end],
				["checksum", agent: NATURAL_32_REF do Result := checksum.to_reference end],
				["id", agent: STRING do Result := id.to_hex_string end]
			>>)
		end

end

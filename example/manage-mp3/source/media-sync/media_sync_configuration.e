note
	description: "Summary description for {MEDIA_SYNC_CONFIGURATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 11:12:58 GMT (Monday 24th June 2013)"
	revision: "2"

class
	MEDIA_SYNC_CONFIGURATION

inherit
	EL_BUILDABLE_XML_FILE_PERSISTENT
		redefine
			make, building_action_table, getter_function_table
		end

	EL_MODULE_LOG

create
	make, make_from_file

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			unique_file_id := 1
		end

feature -- Access

	unique_file_id: INTEGER

feature -- Element change

	set_next_unique_file_id
			--
		do
			unique_file_id := unique_file_id + 1
		end

feature {NONE} -- Evolicity fields

	get_unique_file_id: INTEGER_REF
			--
		do
			Result := unique_file_id.to_reference
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["unique_file_id", agent get_unique_file_id]
			>>)
		end

feature {NONE} -- Building from XML

	set_unique_file_id_from_node
			--
		do
			log.enter ("set_unique_file_id_from_node")
			unique_file_id := node.to_integer
			log.exit
		end

	building_action_table: like Type_building_actions
			-- Nodes relative to root element: media-sync-config
		do
			-- Call precursor to include xmlns attribute
			create Result.make (<<
				["unique-file-id/text()", agent set_unique_file_id_from_node]
			>>)
		end

	Root_node_name: STRING = "media-sync-config"

feature -- Constants

	UFID_name: STRING = "UFID"

feature {NONE} -- Constants

	Template: STRING_32 =
		-- Substitution template

	"[
		<?xml version="1.0" encoding="UTF-8"?>
		<media-sync-config>
			<unique-file-id>$unique_file_id</unique-file-id>
		</media-sync-config>
	]"

end

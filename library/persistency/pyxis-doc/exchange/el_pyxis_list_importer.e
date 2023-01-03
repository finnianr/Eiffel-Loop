note
	description: "Import items from file created by {[$source EL_PYXIS_CHAIN_IMPORT_EXPORT]}.export_pyxis"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-03 12:49:58 GMT (Tuesday 3rd January 2023)"
	revision: "6"

class
	EL_PYXIS_LIST_IMPORTER [G -> EL_REFLECTIVELY_SETTABLE create make_default end]

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		redefine
			make
		end

	EL_MODULE_PYXIS

create
	make

feature {NONE} -- Initialization

	make (a_file_path: FILE_PATH)
		require else
			file_exists: a_file_path.exists
		do
			create list.make (Pyxis.element_count (a_file_path, "item", 1))
			root_node_name := Pyxis.root_element_name_for_type ({G})

			create item_context.make (new_item)
			Precursor (a_file_path)
		end

feature -- Access

	list: EL_ARRAYED_LIST [G]

	software_version: NATURAL

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["item", agent set_extended_list_context],
				["@software_version", agent do software_version := node end]
			>>)
		end

	set_extended_list_context
		do
			list.extend (create {G}.make_default)
			item_context.set_object (list.last)
			set_next_context (item_context)
		end

feature {NONE} -- Implementation

	new_item: G
		do
			create Result.make_default
		end

feature {NONE} -- Internal attributes

	item_context: EL_REFLECTIVE_OBJECT_BUILDER_CONTEXT

	root_node_name: STRING

end
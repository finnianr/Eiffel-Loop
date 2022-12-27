note
	description: "Import items from file created by [$source EL_PYXIS_OBJECT_EXPORTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-27 17:22:01 GMT (Tuesday 27th December 2022)"
	revision: "1"

class
	EL_PYXIS_OBJECT_IMPORTER [G -> EL_REFLECTIVELY_SETTABLE create make_default end]

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make (a_file_path: FILE_PATH)
		require else
			file_exists: a_file_path.exists
		local
			file: PLAIN_TEXT_FILE; item_count: INTEGER
		do
			create file.make_open_read (a_file_path)
			from until file.end_of_file loop
				file.read_line
				if file.last_string.starts_with (Tab_item) then
					item_count := item_count + 1
				end
			end
			file.close
			create list.make (item_count)
			root_node_name := ({G}).name
			root_node_name.to_lower

			create item_context.make (new_item)

			Precursor (a_file_path)
		end

feature -- Access

	list: EL_ARRAYED_LIST [G]

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["item", agent extend_item]
			>>)
		end

	extend_item
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

	item_context: EL_EIF_REFLECTIVE_BUILDER_CONTEXT

	root_node_name: STRING

feature {NONE} -- Constants

	Tab_item: STRING = "%Titem:"

end
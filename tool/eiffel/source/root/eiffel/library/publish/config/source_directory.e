note
	description: "Source directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 15:13:09 GMT (Monday 5th December 2022)"
	revision: "16"

class
	SOURCE_DIRECTORY

inherit
	ANY

	EVOLICITY_EIFFEL_CONTEXT

	EL_MODULE_XML

create
	make

feature {NONE} -- Initialization

	make (a_library_ecf: like library_ecf; a_index: like index)
			--
		do
			make_default
			library_ecf := a_library_ecf; index := a_index
			relative_dir := a_library_ecf.relative_dir_path
			create class_list.make (10)
		end

feature -- Access

	class_list: EL_ARRAYED_LIST [EIFFEL_CLASS]

	contents_dir_title: ZSTRING
		do
			Result := dir_title.twin
			if Result /~ Current_dir then
				Result.prepend_string_general (once ". /")
			end
		end

	dir_title: ZSTRING
		local
			first_dir: DIR_PATH
		do
			if class_list.is_empty then
				create Result.make_empty
			else
				first_dir := class_list.first.relative_source_path.parent
				if relative_dir.is_parent_of (first_dir) then
					Result := first_dir.relative_path (relative_dir)
				else
					Result := Current_dir
				end
			end
		end

	dir_path: DIR_PATH
		require
			has_classes: class_list.count > 0
		do
			if class_list.count > 0 then
				Result := class_list.first.source_path.parent
			else
				create Result
			end
		end

	index: INTEGER

	relative_dir: DIR_PATH

	sorted_class_list: EL_SORTABLE_ARRAYED_LIST [EIFFEL_CLASS]
		local
			l_class: EIFFEL_CLASS
		do
			create Result.make (class_list.count)
			across class_list as c loop
				l_class := c.item
				Result.extend (l_class.twin)
				Result.last.notes.set_relative_class_dir (library_ecf.html_index_path.parent)
			end
			Result.sort
		end

feature -- Status query

	is_modified: BOOLEAN
		do
			Result := across class_list as l_class some l_class.item.is_modified end
		end

	is_empty: BOOLEAN
		do
			Result := class_list.is_empty
		end

feature -- Basic operations

	read_class_notes
		do
			class_list.do_all (agent {EIFFEL_CLASS}.fill_notes)
		end

	write_class_html
		do
			across class_list as l_class loop
				if l_class.item.is_modified then
					l_class.item.serialize
				end
			end
		end

feature {NONE} -- Evolicity fields

	get_section: ZSTRING
		do
			Result := dir_title
			if Result.starts_with_zstring (Dot_slash) then
				Result.remove_head (2)
			end
			Result.replace_character ('/', '-')
			Result := XML.escaped (Result)
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["class_list", 			agent: like class_list do Result := sorted_class_list end],
				["contents_dir_title", 	agent: ZSTRING do Result := XML.escaped (contents_dir_title) end],
				["dir_title", 				agent: ZSTRING do Result := XML.escaped (dir_title) end],
				["section", 				agent get_section]
			>>)
		end

feature {NONE} -- Internal attributes

	library_ecf: EIFFEL_CONFIGURATION_FILE

feature {NONE} -- Constants

	Current_dir: ZSTRING
		once
			Result := "[ . ]"
		end

	Dot_slash: ZSTRING
		once
			Result := "./"
		end

end
note
	description: "Source directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "6"

class
	SOURCE_DIRECTORY

inherit
	EVOLICITY_EIFFEL_CONTEXT

	EL_MODULE_XML

create
	make

feature {NONE} -- Initialization

	make (a_relative_dir: EL_DIR_PATH; a_class_list: like class_list; a_index: like index)
			--
		do
			make_default
			relative_dir := a_relative_dir; class_list := a_class_list; index := a_index
		end

feature -- Access

	class_list: EL_ARRAYED_LIST [EIFFEL_CLASS]

	dir_title: ZSTRING
		local
			first_dir: EL_DIR_PATH
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

	contents_dir_title: ZSTRING
		do
			Result := dir_title.twin
			if Result /~ Current_dir then
				Result.prepend_string_general (once ". /")
			end
		end

	index: INTEGER

	sorted_class_list: EL_SORTABLE_ARRAYED_LIST [EIFFEL_CLASS]
		local
			l_class: EIFFEL_CLASS
		do
			create Result.make (class_list.count)
			across class_list as c loop
				l_class := c.item
				Result.extend (l_class.twin)
				Result.last.notes.set_relative_class_dir (relative_dir)
			end
			Result.sort
		end

	relative_dir: EL_DIR_PATH

feature -- Status query

	is_modified: BOOLEAN
		do
			Result := across class_list as l_class some l_class.item.is_modified end
		end

feature -- Basic operations

	read_class_notes
		do
			class_list.do_all (agent {EIFFEL_CLASS}.fill_notes)
		end

	write_class_html (class_index_top_dir: STRING)
		do
			across class_list as l_class loop
				if l_class.item.is_modified then
					l_class.item.set_class_index_top_dir (class_index_top_dir)
					l_class.item.serialize
				end
			end
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["class_list", 			agent: like class_list do Result := sorted_class_list end],
				["contents_dir_title", 	agent: ZSTRING do Result := XML.escaped (contents_dir_title) end],
				["dir_title", 				agent: ZSTRING do Result := XML.escaped (dir_title) end],
				["index", 					agent: INTEGER_REF do Result := index.to_reference end]
			>>)
		end

feature {NONE} -- Constants

	Current_dir: ZSTRING
		once
			Result := "[ . ]"
		end

end

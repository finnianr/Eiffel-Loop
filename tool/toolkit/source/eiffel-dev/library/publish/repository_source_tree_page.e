note
	description: "Summary description for {EIFFEL_REPOSITORY_SOURCE_TREE_PAGE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-11 16:44:30 GMT (Monday 11th July 2016)"
	revision: "4"

class
	REPOSITORY_SOURCE_TREE_PAGE

inherit
	REPOSITORY_HTML_PAGE
		rename
			make as make_page
		undefine
			is_equal
		redefine
			getter_function_table, serialize
		end

	COMPARABLE

	EL_MODULE_LOG
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_repository: like repository; a_source_tree: like source_tree)
		do
			repository := a_repository; source_tree := a_source_tree
			make_page (repository)
		end

feature -- Status query

	is_index_page: BOOLEAN
		do
			Result := False
		end

feature -- Access

	name: ZSTRING
		do
			Result := source_tree.name
		end

	relative_file_path: EL_FILE_PATH
		do
			Result := relative_path + "class-index.html"
		end

	title: ZSTRING
		do
			Result := Title_template #$ [repository.name, category, name]
		end

feature -- Access

	category: ZSTRING
		do
			Result := relative_path.first_step.as_proper_case
		end

	relative_path: EL_DIR_PATH
		do
			Result := source_tree.dir_path.relative_path (repository.root_dir)
		end

feature -- Status query

	has_sub_directory: BOOLEAN
		do
			Result := source_tree.directory_list.count > 1
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if category ~ other.category then
				Result := name < other.name
			else
				Result := category < other.category
			end
		end

feature -- Status query

	is_modified: BOOLEAN
		do
			Result := across source_tree.directory_list as l_directory some l_directory.item.is_modified end
		end

feature -- Basic operations

	serialize
		do
			lio.put_line (name)
			across source_tree.directory_list as l_directory loop
				if l_directory.item.is_modified then
					lio.put_character ('.')
					l_directory.item.write_class_html (top_dir)
				end
			end
			lio.put_new_line
			Precursor
		end

feature {NONE} -- Implementation

	step_count: INTEGER
		do
			Result := relative_path.steps.count
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["category",			 	agent: ZSTRING do Result := category end],
				["relative_path",			agent: ZSTRING do Result := relative_path end],
				["directory_list", 		agent: ITERABLE [EIFFEL_SOURCE_DIRECTORY] do Result := source_tree.directory_list end],
				["has_sub_directory", 	agent: BOOLEAN_REF do Result := has_sub_directory.to_reference end]
			>>)
		end

feature {NONE} -- Internal attributes

	source_tree: REPOSITORY_SOURCE_TREE

feature {NONE} -- Constants

	Title_template: ZSTRING
		once
			Result := "%S %S: %S"
		end
end

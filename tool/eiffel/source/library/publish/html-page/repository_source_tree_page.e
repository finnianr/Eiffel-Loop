note
	description: "Repository source tree page"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-07-01 14:33:48 GMT (Sunday 1st July 2018)"
	revision: "7"

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

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32
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
			category := relative_path.first_step.as_proper_case
			sort_category := new_sort_category
			make_sync_item (output_path)
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
			Result := Title_template #$ [repository.name, category_title, name]
		end

feature -- Access

	category: ZSTRING

	category_title: ZSTRING
		-- displayed category title
		do
			if sub_category.is_empty then
				Result := category
			else
				Result := sub_category + Space_string + category
			end
		end

	category_index_title: ZSTRING
		-- Category title for sitemap index
		do
			Result := category.twin
			if Result [Result.count] = 'y' then
				Result.remove_tail (1); Result.append_string_general ("ies")
			else
				Result.append_character ('s')
			end
			if category ~ Library_category then
				Result := Category_title_template  #$ [Result, sub_category]
			end
		end

	relative_path: EL_DIR_PATH
		do
			Result := source_tree.dir_path.relative_path (repository.root_dir)
		end

	sub_category: ZSTRING
		local
			words: EL_ZSTRING_LIST
		do
			if category ~ Library_category then
				create words.make_with_separator (relative_path.steps [2], '_', False)
				Result := words.joined_propercase_words
			else
				create Result.make_empty
			end
		end

	sort_category: ZSTRING

feature -- Status query

	has_sub_directory: BOOLEAN
		do
			Result := source_tree.directory_list.count > 1
		end

	has_ecf_name: BOOLEAN
		do
			Result := not source_tree.ecf_name.is_empty
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if sort_category ~ other.sort_category then
				Result := name < other.name
			else
				Result := sort_category < other.sort_category
			end
		end

feature -- Basic operations

	serialize
		do
			lio.put_line (name)
			across source_tree.directory_list as l_directory loop
				l_directory.item.read_class_notes
				if l_directory.item.is_modified then
					lio.put_character ('.')
					l_directory.item.write_class_html (top_dir)
				end
			end
			lio.put_new_line
			Precursor
		end

feature {NONE} -- Implementation

	content_template: EL_FILE_PATH
		do
			Result := repository.templates.directory_content
		end

	home_description_elements: NOTE_HTML_TEXT_ELEMENT_LIST
		do
			create Result.make (source_tree.description_lines, Empty_string)
		end

	description_elements: NOTE_HTML_TEXT_ELEMENT_LIST
		do
			create Result.make (source_tree.description_lines, relative_file_path.parent)
		end

	sink_content (crc: like crc_generator)
		do
			crc.add_file (template_path)
			across source_tree.description_lines as line loop
				crc.add_string (line.item)
			end
			across source_tree.directory_list as dir loop
				across dir.item.sorted_class_list as l_class loop
					crc.add_natural (l_class.item.current_digest)
				end
			end
		end

	step_count: INTEGER
		do
			Result := relative_path.step_count
		end

	new_sort_category: ZSTRING
		do
			Result := category
			if category ~ Library_category then
				Result := category + Space_string + sub_category
			end
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["home_description_elements",	agent home_description_elements] +
				["description_elements",		agent description_elements] +

				["category_title",	 			agent: ZSTRING do Result := category_title end] +
				["ecf_name",			 			agent: ZSTRING do Result := source_tree.ecf_name end] +
				["directory_list", 				agent: ITERABLE [SOURCE_DIRECTORY] do Result := source_tree.directory_list end] +
				["has_ecf_name",					agent: BOOLEAN_REF do Result := has_ecf_name.to_reference end] +
				["has_sub_directory", 			agent: BOOLEAN_REF do Result := has_sub_directory.to_reference end] +
				["relative_path",					agent: ZSTRING do Result := relative_path end]
		end

feature {NONE} -- Internal attributes

	source_tree: REPOSITORY_SOURCE_TREE

feature {NONE} -- Constants

	Category_title_template: ZSTRING
		once
			Result := "%S (%S)"
		end

	Library_category: ZSTRING
		once
			Result := "Library"
		end

	Title_template: ZSTRING
		once
			Result := "%S %S: %S"
		end
end

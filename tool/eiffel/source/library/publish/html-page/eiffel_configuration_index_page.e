note
	description: "Index page for classes from Eiffel configuration file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 14:36:16 GMT (Wednesday 17th October 2018)"
	revision: "9"

class
	EIFFEL_CONFIGURATION_INDEX_PAGE

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

	make (a_repository: like repository; a_source_tree: like library_ecf)
		do
			repository := a_repository; library_ecf := a_source_tree
			make_page (repository)
			sort_category := new_sort_category
			make_sync_item (output_path)
		end

feature -- Access

	name: ZSTRING
		do
			Result := library_ecf.name
		end

	relative_file_path: EL_FILE_PATH
		do
			Result := library_ecf.html_index_path
		end

	title: ZSTRING
		do
			Result := Title_template #$ [repository.name, category_title, name]
		end

feature -- Access

	category: ZSTRING
		do
			Result := library_ecf.category
		end

	category_title: ZSTRING
		-- displayed category title
		do
			if sub_category.is_empty then
				Result := category
			else
				Result := sub_category + character_string (' ') + category
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
			if library_ecf.is_library then
				Result := Category_title_template  #$ [Result, sub_category]
			end
		end

	relative_path: EL_DIR_PATH
		do
			Result := library_ecf.relative_dir_path
		end

	sub_category: ZSTRING
		do
			Result := library_ecf.sub_category
		end

	sort_category: ZSTRING

feature -- Status query

	has_sub_directory: BOOLEAN
		do
			Result := library_ecf.directory_list.count > 1
		end

	has_ecf_name: BOOLEAN
		do
			Result := not library_ecf.relative_ecf_path.is_empty
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
			lio.put_labeled_string ("Updating", name)
			lio.put_new_line
			across library_ecf.directory_list as l_directory loop
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
			create Result.make (library_ecf.description_lines, Empty_string)
		end

	description_elements: NOTE_HTML_TEXT_ELEMENT_LIST
		do
			create Result.make (library_ecf.description_lines, relative_file_path.parent)
		end

	sink_content (crc: like crc_generator)
		do
			crc.add_file (content_template)
			crc.add_string (library_ecf.name)
			across library_ecf.description_lines as line loop
				crc.add_string (line.item)
			end
			across library_ecf.directory_list as dir loop
				across dir.item.sorted_class_list as l_class loop
					crc.add_natural (l_class.item.current_digest)
				end
			end
		end

	step_count: INTEGER
		do
			Result := relative_file_path.step_count - 1
		end

	new_sort_category: ZSTRING
		do
			if library_ecf.is_library then
				Result := category + character_string (' ') + sub_category
			else
				Result := category
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
				["class_count",					agent: INTEGER_REF do Result := library_ecf.class_count.to_reference end] +
				["directory_list", 				agent: ITERABLE [SOURCE_DIRECTORY] do Result := library_ecf.directory_list end] +
				["ecf_name",			 			agent: ZSTRING do Result := library_ecf.relative_ecf_path.base end] +
				["ecf_path",			 			agent: ZSTRING do Result := library_ecf.relative_ecf_path end] +
				["github_url",			 			agent: ZSTRING do Result := repository.github_url end] +
				["has_ecf_name",					agent: BOOLEAN_REF do Result := has_ecf_name.to_reference end] +
				["has_sub_directory", 			agent: BOOLEAN_REF do Result := has_sub_directory.to_reference end] +
				["relative_path",					agent: ZSTRING do Result := relative_path end]
		end

feature {NONE} -- Internal attributes

	library_ecf: EIFFEL_CONFIGURATION_FILE

feature {NONE} -- Constants

	Category_title_template: ZSTRING
		once
			Result := "%S (%S)"
		end

	Title_template: ZSTRING
		once
			Result := "%S %S: %S"
		end
end

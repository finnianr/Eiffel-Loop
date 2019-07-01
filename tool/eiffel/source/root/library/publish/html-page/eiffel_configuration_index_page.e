note
	description: "Index page for classes from Eiffel configuration file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-05 17:27:23 GMT (Tuesday 5th March 2019)"
	revision: "14"

class
	EIFFEL_CONFIGURATION_INDEX_PAGE

inherit
	REPOSITORY_HTML_PAGE
		rename
			make as make_page
		undefine
			is_equal
		redefine
			getter_function_table, serialize, is_modified
		end

	COMPARABLE

	EL_MODULE_LOG

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

create
	make

feature {NONE} -- Initialization

	make (a_repository: like repository; a_source_tree: like eiffel_config)
		do
			repository := a_repository; eiffel_config := a_source_tree
			make_page (repository)
			sort_category := new_sort_category
			make_sync_item (output_path)
		end

feature -- Access

	name: ZSTRING
		do
			Result := eiffel_config.name
		end

	relative_file_path: EL_FILE_PATH
		do
			Result := eiffel_config.html_index_path
		end

	title: ZSTRING
		do
--			Result := Title_template #$ [repository.name, category_title, name]
			Result := relative_file_path.without_extension.base
		end

feature -- Access

	category: ZSTRING
		do
			Result := eiffel_config.category
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
			if eiffel_config.is_library then
				Result := Category_title_template #$ [Result, sub_category]
			end
		end

	relative_path: EL_DIR_PATH
		do
			Result := eiffel_config.relative_dir_path
		end

	sub_category: ZSTRING
		do
			Result := eiffel_config.sub_category
		end

	sort_category: ZSTRING

feature -- Status query

	has_sub_directory: BOOLEAN
		do
			Result := eiffel_config.directory_list.count > 1
		end

	has_ecf_name: BOOLEAN
		do
			Result := not eiffel_config.relative_ecf_path.is_empty
		end

	is_modified: BOOLEAN
		do
			Result := Precursor or else
				across eiffel_config.directory_list as dir some
					across dir.item.class_list as l_class some
						l_class.item.is_modified
					end
				end
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
			across eiffel_config.directory_list as l_directory loop
				l_directory.item.read_class_notes
				if l_directory.item.is_modified then
					lio.put_character ('.')
					l_directory.item.write_class_html
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

	description_elements: NOTE_HTML_TEXT_ELEMENT_LIST
		do
			create Result.make (eiffel_config.description_lines, relative_file_path.parent)
		end

	sink_content (crc: like crc_generator)
		do
			crc.add_file (content_template)
			crc.add_string (eiffel_config.name)
			across eiffel_config.description_lines as line loop
				crc.add_string (line.item)
			end
			across eiffel_config.directory_list as dir loop
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
			if eiffel_config.is_library then
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
				-- Status query
				["has_ecf_name",					agent: BOOLEAN_REF do Result := has_ecf_name.to_reference end] +
				["has_sub_directory", 			agent: BOOLEAN_REF do Result := has_sub_directory.to_reference end] +

				["description_count",			agent: INTEGER_REF do Result := eiffel_config.description_lines.character_count end] +
				["class_count",					agent: INTEGER_REF do Result := eiffel_config.class_count.to_reference end] +

				["directory_list", 				agent: ITERABLE [SOURCE_DIRECTORY] do Result := eiffel_config.directory_list end] +
				["description_elements",		agent description_elements] +
				["category_title",	 			agent: ZSTRING do Result := category_title end] +
				["ecf_name",			 			agent: ZSTRING do Result := eiffel_config.relative_ecf_path.base end] +
				["ecf_path",			 			agent: ZSTRING do Result := eiffel_config.relative_ecf_path end] +
				["github_url",			 			agent: ZSTRING do Result := repository.github_url end] +
				["relative_path",					agent: ZSTRING do Result := relative_path end] +
				["type",								agent: STRING do Result := eiffel_config.type end]
		end

feature {NONE} -- Internal attributes

	eiffel_config: EIFFEL_CONFIGURATION_FILE

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

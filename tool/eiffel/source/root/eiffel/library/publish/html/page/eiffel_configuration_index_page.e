note
	description: "Index page for classes from Eiffel configuration file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-24 6:38:23 GMT (Thursday 24th August 2023)"
	revision: "26"

class
	EIFFEL_CONFIGURATION_INDEX_PAGE

inherit
	REPOSITORY_HTML_PAGE
		rename
			make as make_page
		undefine
			is_equal
		redefine
			getter_function_table, serialize, is_modified, sink_content
		end

	COMPARABLE

	EL_MODULE_LIO

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

create
	make

feature {NONE} -- Initialization

	make (a_repository: like repository; a_eiffel_config: like eiffel_config)
		do
			repository := a_repository; eiffel_config := a_eiffel_config
			make_page (repository)
			sort_category := a_eiffel_config.new_sort_category
			make_sync_item (
				repository.output_dir, repository.ftp_host, output_path.relative_path (repository.output_dir), 0
			)
		end

feature -- Access

	name: ZSTRING
		do
			Result := eiffel_config.name
		end

	relative_file_path: FILE_PATH
		do
			Result := eiffel_config.html_index_path
		end

	title: ZSTRING
		do
--			Result := Title_template #$ [repository.name, category_title, name]
			Result := relative_file_path.without_extension.base
		end

feature -- Access

	category_id: ZSTRING
		-- for use in <a id="$category_id">
		do
			Result := category_index_title.as_lower
			Result.translate_and_delete (Category_id_characters.existing, Category_id_characters.replacement)
		end

	category_index_title: ZSTRING
		-- Category title for sitemap index
		do
			Result := eiffel_config.category_index_title
		end

	relative_path: DIR_PATH
		do
			Result := eiffel_config.relative_dir_path
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

	content_template: FILE_PATH
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
				["category_title",	 			agent: ZSTRING do Result := eiffel_config.category_title end] +
				["ecf_name",			 			agent: ZSTRING do Result := eiffel_config.relative_ecf_path.base end] +
				["ecf_path",			 			agent: ZSTRING do Result := eiffel_config.relative_ecf_path end] +
				["github_url",			 			agent: ZSTRING do Result := repository.github_url end] +
				["relative_path",					agent: ZSTRING do Result := relative_path end] +
				["type",								agent: STRING do Result := eiffel_config.type end]
		end

feature {NONE} -- Internal attributes

	eiffel_config: EIFFEL_CONFIGURATION_FILE

feature {NONE} -- Constants

	Category_id_characters: TUPLE [existing, replacement: ZSTRING]
		once
			create Result
			Result.existing := " ()"
			Result.replacement := "_%U%U" -- delete brackets
		end

	Title_template: ZSTRING
		once
			Result := "%S %S: %S"
		end
end
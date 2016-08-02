note
	description: "Summary description for {EIFFEL_REPOSITORY_SOURCE_TREE_PAGE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-27 13:32:45 GMT (Wednesday 27th July 2016)"
	revision: "1"

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

	EL_HTML_META_DIGEST_PARSER
		rename
			make as make_meta_digest
		undefine
			is_equal
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
		local
			l_crc: like crc_generator
		do
			repository := a_repository; source_tree := a_source_tree
			l_crc := crc_generator
			across a_source_tree.description_lines as line loop
				l_crc.add_string (line.item)
			end
			description_checksum := l_crc.checksum
			make_page (repository)
			make_meta_digest (output_path)
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

	category_plural: ZSTRING
		do
			Result := category
			if Result [Result.count] = 'y' then
				Result.remove_tail (1); Result.append_string_general ("ies")
			else
				Result.append_character ('s')
			end
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

	has_ecf_name: BOOLEAN
		do
			Result := not source_tree.ecf_name.is_empty
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
			Result := description_checksum /= meta_crc_digest or else
							across source_tree.directory_list as l_directory some l_directory.item.is_modified end
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

	home_description_elements: HTML_TEXT_ELEMENT_LIST
		do
			create Result.make (source_tree.description_lines)
		end

	description_elements: EIFFEL_NOTE_HTML_TEXT_ELEMENT_LIST
		do
			create Result.make (source_tree.description_lines, top_dir)
		end

	description_checksum: NATURAL

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
				["home_description_elements",	agent home_description_elements],
				["description_elements",		agent description_elements],

				["category",			 			agent: ZSTRING do Result := category end],
				["ecf_name",			 			agent: ZSTRING do Result := source_tree.ecf_name end],
				["directory_list", 				agent: ITERABLE [EIFFEL_SOURCE_DIRECTORY] do Result := source_tree.directory_list end],
				["has_ecf_name",					agent: BOOLEAN_REF do Result := has_ecf_name.to_reference end],
				["has_sub_directory", 			agent: BOOLEAN_REF do Result := has_sub_directory.to_reference end],
				["relative_path",					agent: ZSTRING do Result := relative_path end],
				["crc_digest",						agent: NATURAL_32_REF do Result := description_checksum.to_reference end]
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

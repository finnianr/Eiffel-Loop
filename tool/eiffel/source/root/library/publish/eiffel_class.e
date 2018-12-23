note
	description: "[
		Class to render github like markdown found in the description note field of Eiffel classes.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 13:50:15 GMT (Wednesday 17th October 2018)"
	revision: "12"

class
	EIFFEL_CLASS

inherit
	EL_HTML_FILE_SYNC_ITEM
		rename
			make as make_sync_item,
			file_path as ftp_file_path
		undefine
			is_equal, copy
		end

	EVOLICITY_SERIALIZEABLE
		rename
			output_path as html_output_path
		undefine
			is_equal
		redefine
			make_default, serialize, copy
		end

	COMPARABLE
		undefine
			copy
		end

	EL_MODULE_DIRECTORY
		undefine
			is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

	EL_MODULE_UTF
		undefine
			is_equal, copy
		end

	EL_MODULE_XML
		undefine
			is_equal, copy
		end

	EL_ZSTRING_CONSTANTS
		undefine
			is_equal, copy
		end

	SHARED_HTML_CLASS_SOURCE_TABLE
		undefine
			is_equal, copy
		end

	EL_EIFFEL_KEYWORDS
		undefine
			is_equal, copy
		end

	EL_SINGLE_THREAD_ACCESS
		undefine
			is_equal, copy
		redefine
			make_default
		end

create
	make

feature {NONE} -- Initialization

	make (a_source_path: like source_path; a_library_ecf: like library_ecf; a_repository: like repository)
			--
		do
			relative_source_path := a_source_path.relative_path (a_repository.root_dir)
			make_from_template_and_output (
				a_repository.templates.eiffel_source, a_repository.output_dir + relative_source_path.with_new_extension ("html")
			)
			library_ecf := a_library_ecf; repository := a_repository; source_path := a_source_path
			name := source_path.base_sans_extension.as_upper
			code_text := new_code_text (File_system.plain_text (source_path))
			make_sync_item (html_output_path)

			create notes.make (relative_source_path.parent, a_repository.note_fields)
			create stats.make (a_source_path)
			restrict_access
				Class_source_table.put (relative_source_path.with_new_extension (Html), name)
			end_restriction
		end

	make_default
		do
			create source_path
			create name.make_empty
			create class_index_top_dir
			make_machine
			Precursor {EL_SINGLE_THREAD_ACCESS}
			Precursor {EVOLICITY_SERIALIZEABLE}
		end

feature -- Access

	code_text: ZSTRING

	class_index_top_dir: EL_DIR_PATH
		-- top level directory relative to class-index.html for this class

	class_text: ZSTRING
		do
			Result := XML.escaped (code_text.substring_end (class_begin_index + 1))
		end

	notes_text: ZSTRING
		do
			Result := XML.escaped (code_text.substring (1, class_begin_index))
		end

	notes: EIFFEL_NOTES

	name: STRING

	relative_html_path: EL_FILE_PATH
		-- html path relative to `library_ecf.ecf_dir'
		do
			Result := source_path.relative_path (library_ecf.dir_path)
			Result := source_path.relative_dot_path (library_ecf.ecf_path).with_new_extension ("html")
		end

	relative_source_path: EL_FILE_PATH

	source_path: EL_FILE_PATH

	stats: CLASS_STATISTICS

feature -- Status report

	has_class_name (a_name: ZSTRING): BOOLEAN
		local
			pos_name: INTEGER; c_left, c_right: CHARACTER_32
			l_text: like code_text
		do
			l_text := code_text
			from pos_name := 1 until Result or pos_name = 0 loop
				pos_name := l_text.substring_index (a_name, pos_name)
				if pos_name > 0 then
					c_left := l_text.item (pos_name - 1)
					c_right := l_text.item (pos_name + a_name.count)
					if (c_left.is_alpha or c_left = '_') or else (c_right.is_alpha or c_right = '_') then
						pos_name := (pos_name + a_name.count).min (l_text.count)
					else
						Result := True
					end
				end
			end
		end

	has_further_information: BOOLEAN
		do
			Result := not further_information_fields.is_empty
		end

	is_library: BOOLEAN
		do
			Result := relative_source_path.first_step ~ Library
		end

	notes_filled: BOOLEAN

feature -- Basic operations

	check_class_references
		do
			fill_notes
			notes.check_class_references (source_path.base)
		end

	fill_notes
		do
			notes.fill (source_path)
			notes_filled := True
		end

	serialize
		do
			if not notes_filled then
				fill_notes
			end
			Precursor
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if notes.has_description = other.notes.has_description then
				Result := name < other.name

			else
				Result := notes.has_description
			end
		end

feature -- Element change

	set_class_index_top_dir (a_class_index_top_dir: like class_index_top_dir)
		do
			class_index_top_dir := a_class_index_top_dir
		end

feature {NONE} -- Implementation

	copy (other: like Current)
		do
			standard_copy (other)
			notes := other.notes.twin
		end

	class_begin_index: INTEGER
		do
			across Class_begin_strings as string until Result > 0 loop
				Result := code_text.substring_index (string.item, 1)
			end
		end

	ftp_file_path: EL_FILE_PATH
		do
			Result := html_output_path.relative_path (repository.output_dir)
		end

	relative_ecf_html_path: ZSTRING
		do
			Result := library_ecf.html_index_path.relative_dot_path (relative_source_path)
		end

	top_dir: EL_DIR_PATH
		do
			Result := Directory.relative_parent (relative_source_path.step_count - 1)
		end

	further_information_fields: EL_ZSTRING_LIST
		do
			Result := notes.other_field_titles
		end

	further_information: ZSTRING
			-- other information besides the description
		local
			pos_comma: INTEGER
		do
			Result := further_information_fields.joined_with_string (", ")
			if not Result.is_empty then
				pos_comma := Result.last_index_of (',', Result.count)
				if pos_comma > 0 then
					Result.replace_substring_general (" and", pos_comma, pos_comma)
				end
				Result.to_lower
			end
		end

	sink_content (crc: like crc_generator)
		do
			crc.add_string (code_text)
			crc.add_string (relative_source_path)
		end

feature {NONE} -- Factory

	new_code_text (raw_source: STRING): ZSTRING
		do
			if raw_source.starts_with (UTF.Utf_8_bom_to_string_8) then
				raw_source.remove_head (UTF.Utf_8_bom_to_string_8.count)
				create Result.make_from_utf_8 (raw_source)
			else
				Result := raw_source
			end
		end

feature {NONE} -- Internal attributes

	repository: REPOSITORY_PUBLISHER

	library_ecf: EIFFEL_CONFIGURATION_FILE

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["description_elements",	agent: like notes.description_elements do Result := notes.description_elements end],
				["note_fields",				agent: like notes.field_list do Result := notes.field_list end],
				["has_description",			agent: BOOLEAN_REF do Result := notes.has_description.to_reference end],

				["crc_digest", 				agent current_digest_ref],
				["notes_text", 				agent notes_text],
				["class_text", 				agent class_text],
				["further_information",		agent further_information],
				["has_further_information",agent: BOOLEAN_REF do Result := has_further_information.to_reference end],
				["has_fields",					agent: BOOLEAN_REF do Result := notes.has_fields.to_reference end],
				["name", 						agent: STRING do Result := name.string end],
				["name_as_lower", 			agent: STRING do Result := name.string.as_lower end],
				["html_path", 					agent: ZSTRING do Result := relative_html_path end],
				["favicon_markup_path", 	agent: ZSTRING do Result := repository.templates.favicon_markup_path end],
				["relative_dir", 				agent: EL_DIR_PATH do Result := relative_source_path.parent end],
				["ecf_contents_path", 		agent relative_ecf_html_path],
				["is_library", 				agent: BOOLEAN_REF do Result := is_library.to_reference end],
				["source_path", 				agent: EL_FILE_PATH do Result := relative_source_path end],
				["top_dir", 					agent top_dir]
			>>)
		end

feature {NONE} -- Constants

	Class_begin_strings: EL_ZSTRING_LIST
		once
			create Result.make (3)
			across Class_declaration_keywords as keyword loop
				Result.extend (character_string ('%N') + keyword.item)
			end
		end

	Html: ZSTRING
		once
			Result := "html"
		end

	Relative_root: EL_DIR_PATH
		once
			create Result
		end

	Library: ZSTRING
		once
			Result := "library"
		end

	Note_description: ZSTRING
		once
			Result := "description"
		end

	Template: STRING = ""

end

note
	description: "[
		Class to render github like markdown found in the description note field of Eiffel classes.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-10 10:32:50 GMT (Tuesday 10th October 2017)"
	revision: "7"

class
	EIFFEL_CLASS

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			output_path as html_path
		undefine
			is_equal
		redefine
			make_default, serialize
		end

	EL_HTML_META_DIGEST_PARSER
		rename
			make as make_meta_digest
		undefine
			is_equal
		end

	COMPARABLE

	EL_MODULE_DIRECTORY
		undefine
			is_equal
		end

	EL_MODULE_LOG
		undefine
			is_equal
		end

	EL_MODULE_UTF
		undefine
			is_equal
		end

	EL_MODULE_XML
		undefine
			is_equal
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal
		end

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32
		undefine
			is_equal
		end

	SHARED_HTML_CLASS_SOURCE_TABLE
		undefine
			is_equal
		end

	EL_EIFFEL_KEYWORDS
		undefine
			is_equal
		end

	EL_SINGLE_THREAD_ACCESS
		undefine
			is_equal
		redefine
			make_default
		end

create
	make

feature {NONE} -- Initialization

	make (a_source_path: like source_path; a_relative_html_path: like relative_html_path; a_repository: like repository)
			--
		local
			l_crc: like crc_generator; raw_source: STRING
		do
			relative_source_path := a_source_path.relative_path (a_repository.root_dir)
			make_from_template_and_output (
				a_repository.templates.eiffel_source, a_repository.output_dir + relative_source_path.with_new_extension ("html")
			)
			source_path := a_source_path; relative_html_path := a_relative_html_path; repository := a_repository
			name := source_path.base_sans_extension.as_upper
			raw_source := File_system.plain_text (source_path)
			l_crc := crc_generator
			l_crc.add_string_8 (raw_source)
			crc_digest := l_crc.checksum
			code_text := new_code_text (raw_source)
			create notes.make (relative_source_path.parent, a_repository.note_fields)
			make_meta_digest (html_path)
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

	relative_source_path: EL_FILE_PATH

	source_path: EL_FILE_PATH

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

	is_modified: BOOLEAN
		do
			Result := crc_digest /= meta_crc_digest
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
			repository.ftp_sync.extend_modified (html_path.relative_path (repository.output_dir))
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

	class_begin_index: INTEGER
		do
			across Class_begin_strings as string until Result > 0 loop
				Result := code_text.substring_index (string.item, 1)
			end
		end

	index_dir: ZSTRING
		do
			Result := Directory.relative_parent (relative_html_path.step_count - 1)
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

	crc_digest: NATURAL
		-- Eiffel source digest

	repository: REPOSITORY_PUBLISHER

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["description_elements",	agent: like notes.description_elements do Result := notes.description_elements end],
				["note_fields",				agent: like notes.field_list do Result := notes.field_list end],
				["has_description",			agent: BOOLEAN_REF do Result := notes.has_description.to_reference end],

				["crc_digest", 				agent: NATURAL_32_REF do Result := crc_digest.to_reference end],
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
				["index_dir", 					agent index_dir],
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
				Result.extend (New_line_string + keyword.item)
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

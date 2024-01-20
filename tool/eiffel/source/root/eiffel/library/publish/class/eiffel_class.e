note
	description: "[
		Class to render github like markdown found in the description note field of Eiffel classes.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "52"

class
	EIFFEL_CLASS

inherit
	EL_FILE_SYNC_ITEM
		rename
			make as make_sync_item,
			source_path as html_source_path
		undefine
			is_equal, copy
		redefine
			sink_content
		end

	EVOLICITY_SERIALIZEABLE
		rename
			output_path as html_output_path
		undefine
			is_equal
		redefine
			make_default, serialize, copy
		end

	COMPARABLE undefine copy end

	EL_THREAD_ACCESS [CODEBASE_METRICS] undefine is_equal, copy end

	EL_EIFFEL_KEYWORDS

	EL_MODULE_DIRECTORY; EL_MODULE_FILE; EL_MODULE_XML

	PUBLISHER_CONSTANTS; EL_ZSTRING_CONSTANTS; EL_CHARACTER_32_CONSTANTS

	SHARED_CODEBASE_METRICS

	EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make

feature {NONE} -- Initialization

	make (a_source_path: like source_path; a_library_ecf: like library_ecf; a_repository: like repository)
			--
		local
			source_text: STRING; utf: EL_UTF_CONVERTER
		do
			relative_source_path := a_source_path.relative_path (a_repository.root_dir)
			make_from_template_and_output (
				a_repository.templates.eiffel_source,
				a_repository.output_dir + relative_source_path.with_new_extension (Html)
			)
			library_ecf := a_library_ecf; repository := a_repository; source_path := a_source_path
			name := source_path.base_name.as_upper
			source_text := File.plain_text (source_path)
			code_text := new_code_text (source_text)
			make_sync_item (
				repository.output_dir, repository.ftp_host, html_output_path.relative_path (repository.output_dir), 0
			)
			create notes.make (relative_source_path.parent, a_repository.note_fields)

			if attached restricted_access (Codebase_metrics) as metrics then
				if utf.is_utf_8_file (source_text) then
					metrics.add_source (source_text, Utf_8)
				else
					metrics.add_source (source_text, Latin_1)
				end
				end_restriction
			end
		end

	make_default
		do
			create source_path
			create name.make_empty
			notes := Default_notes
			Precursor
		end

feature -- Access

	class_text: ZSTRING
		do
			Result := XML.escaped (code_text.substring_end (class_begin_index + 1))
		end

	code_text: ZSTRING

	name: STRING

	notes: EIFFEL_NOTES

	notes_text: ZSTRING
		do
			Result := XML.escaped (code_text.substring (1, class_begin_index))
		end

	relative_html_path: FILE_PATH
		-- html path relative to `library_ecf.ecf_dir'
		do
			Result := source_path.relative_dot_path (library_ecf.ecf_path).with_new_extension (Html)
		end

	relative_source_path: FILE_PATH

	source_path: FILE_PATH

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

	is_example: BOOLEAN
		do
			Result := not is_library
		end

	is_source_modified: BOOLEAN
		-- `True' if file was modified since creation of `Current'
		do
			if attached crc_generator as crc then
				crc.add_string (new_code_text (File.plain_text (source_path)))
				crc.add_string (relative_source_path)
				if initial_current_digest.to_boolean then
					Result := initial_current_digest /= crc.checksum
				else
					Result := current_digest /= crc.checksum
				end
			end
		end

	is_library: BOOLEAN
		do
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

	sink_source_substitutions
		-- sink the values of ${<type-name>} occurrences `code_text'. Eg. ${CLASS_NAME}
		local
			crc: like crc_generator
		do
			crc := crc_generator
			if initial_current_digest.to_boolean then
				current_digest := initial_current_digest
			else
				initial_current_digest := current_digest
			end
			crc.set_checksum (current_digest)
			if attached Class_reference_list as list then
				list.parse (code_text)
				from list.start until list.after loop
					if attached list.item_value.path as path then
						crc.add_path (path)
					end
					list.forth
				end
			end
			current_digest := crc.checksum
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if notes.has_description = other.notes.has_description then
				if name ~ other.name then
					-- Needed to get a consistent `current_digest' in `LIBRARY_CLASS'
					Result := relative_source_path < other.relative_source_path
				else
					Result := name < other.name
				end

			else
				Result := notes.has_description
			end
		end

feature {NONE} -- Implementation

	class_begin_index: INTEGER
		do
			across Class_begin_strings as string until Result > 0 loop
				Result := code_text.substring_index (string.item, 1)
			end
		end

	copy (other: like Current)
		do
			standard_copy (other)
			notes := other.notes.twin
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

	further_information_fields: EL_ZSTRING_LIST
		do
			Result := notes.other_field_titles
		end

	new_code_text (raw_source: STRING): ZSTRING
		local
			utf: EL_UTF_CONVERTER
		do
			if utf.is_utf_8_file (raw_source) then
				create Result.make_from_utf_8 (utf.bomless_utf_8 (raw_source))
			else
				Result := raw_source
			end
		end

	relative_ecf_html_path: ZSTRING
		do
			Result := library_ecf.html_index_path.relative_dot_path (relative_source_path)
		end

	sink_content (crc: like crc_generator)
		do
			crc.add_string (code_text)
			crc.add_string (relative_source_path)
		end

feature {NONE} -- Internal attributes

	library_ecf: EIFFEL_CONFIGURATION_FILE

	repository: REPOSITORY_PUBLISHER

	initial_current_digest: NATURAL
		-- `current_digest' before modification by `sink_source_substitutions'

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["description_elements",	agent: like notes.description_elements do Result := notes.description_elements end],
				["note_fields",				agent: like notes.field_list do Result := notes.field_list end],

				["has_description",			agent: BOOLEAN_REF do Result := notes.has_description.to_reference end],
				["has_further_information",agent: BOOLEAN_REF do Result := has_further_information.to_reference end],
				["has_fields",					agent: BOOLEAN_REF do Result := notes.has_fields.to_reference end],
				["is_library", 				agent: BOOLEAN_REF do Result := is_library.to_reference end],

				["notes_text", 				agent notes_text],
				["class_text", 				agent class_text],
				["further_information",		agent further_information],
				["ecf_contents_path", 		agent relative_ecf_html_path],

				["name", 						agent: STRING do Result := name.string end],
				["name_as_lower", 			agent: STRING do Result := name.string.as_lower end],
				["html_path", 					agent: ZSTRING do Result := relative_html_path end],
				["favicon_markup_path", 	agent: ZSTRING do Result := repository.templates.favicon_markup_path end],
				["top_dir", 					agent: ZSTRING do Result := Directory.relative_parent (relative_source_path.step_count - 1) end],

				["relative_dir", 				agent: DIR_PATH do Result := relative_source_path.parent end],
				["source_path", 				agent: FILE_PATH do Result := relative_source_path end]
			>>)
		end

feature {NONE} -- Constants

	Class_begin_strings: EL_ZSTRING_LIST
		once
			create Result.make (3)
			across Class_declaration_keywords as l_word loop
				Result.extend (new_line * 1 + l_word.item)
			end
		end

	Default_notes: EIFFEL_NOTES
		once
			create Result.make_default
		end

	Template: STRING = ""

end
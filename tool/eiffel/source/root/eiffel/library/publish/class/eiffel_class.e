note
	description: "[
		Class to render github like markdown found in the description note field of Eiffel classes.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-11 10:39:32 GMT (Tuesday 11th June 2024)"
	revision: "66"

class
	EIFFEL_CLASS

inherit
	EIFFEL_CLASS_SERIALIZEABLE
		undefine
			is_equal
		redefine
			copy, make_default
		end

	EL_FILE_SYNC_ITEM
		rename
			make as make_sync_item,
			source_path as html_source_path
		undefine
			copy, is_equal
		redefine
			is_modified, sink_content
		end

	COMPARABLE
		undefine
			copy
		end

create
	make

feature {NONE} -- Initialization

	make (a_source_path: like source_path; a_library_ecf: like library_ecf; a_config: like config)
			--
		local
			class_encoding: NATURAL; analyzer: EIFFEL_SOURCE_ANALYZER
		do
			relative_source_path := a_source_path.relative_path (a_config.root_dir)
			source_parent_base := a_source_path.parent.base
			make_from_template_and_output (
				a_config.templates.eiffel_source,
				a_config.output_dir + relative_source_path.with_new_extension (Html)
			)
			library_ecf := a_library_ecf; config := a_config; source_path := a_source_path
			name := source_path.base_name.as_upper
			if attached File.plain_text (source_path) as source_text then
				class_encoding := source_encoding (source_text)
				code_text := new_code_text (source_text, class_encoding)
				create analyzer.make (source_text, class_encoding)
				metrics := analyzer.metrics
			end
			set_class_use_set

			make_sync_item (
				config.output_dir, config.ftp_host, html_output_path.relative_path (config.output_dir), 0
			)
			create notes.make (relative_source_path.parent, config.note_fields)
		ensure
			initialized: name /= Empty_string and code_text /= Empty_string
		end

	make_default
		do
			create source_path
			name := Empty_string
			code_text := Empty_string
			metrics := Default_metrics
			notes := Default_notes
			Precursor
		end

feature -- Access

	alias_name: detachable ZSTRING
		-- alias for `name' when defined in ECF. `Void' if not.

	class_text: ZSTRING
		do
			Result := XML.escaped (code_text.substring_end (class_begin_index + 1))
		end

	class_use_set: EL_HASH_SET [IMMUTABLE_STRING_8]
		-- set of class names used in `code_text' after first feature marker

	code_text: ZSTRING

	metrics: SPECIAL [INTEGER]
		-- metrics array in alphabetical order of name defined in class `EIFFEL_SOURCE_ANALYZER'

	name: ZSTRING

	notes: EIFFEL_NOTES

	notes_text: ZSTRING
		do
			Result := XML.escaped (code_text.substring (1, class_begin_index))
		end

feature -- File paths

	ecf_relative_html_path: FILE_PATH
		-- html path relative to `library_ecf.ecf_dir'
		do
			Result := source_path.relative_dot_path (library_ecf.ecf_path).with_new_extension (Html)
		end

	relative_html_path: FILE_PATH
		-- HTML path relative to `config.root_dir'
		do
			Result := relative_source_path.with_new_extension (Html)
		end

	relative_source_path: FILE_PATH

	source_path: FILE_PATH

	source_parent_base: ZSTRING
		-- For eg. imp_unix or imp_mswin

feature -- Status report

	has_further_information: BOOLEAN
		do
			Result := not further_information_fields.is_empty
		end

	is_example: BOOLEAN
		do
			Result := not is_library
		end

	is_library: BOOLEAN
		do
		end

	is_modified: BOOLEAN
		do
			if not (html_output_path.exists and digest_path.exists) then
				Result := True
			else
				Result := previous_digest /= current_digest
			end
		end

	is_source_modified: BOOLEAN
		-- `True' if file was modified or moved since creation of `Current'
		do
			if attached crc_generator as crc and then attached File.plain_text (source_path) as source_text then
				crc.add_string (new_code_text (source_text, source_encoding (source_text)))
				crc.add_string (relative_source_path)
				if initial_current_digest.to_boolean then
					Result := initial_current_digest /= crc.checksum
				else
					Result := current_digest /= crc.checksum
				end
			end
		end

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

	sink_source_substitutions
		-- sink the values of ${<type-name>} occurrences `code_text'. Eg. ${CLASS_NAME}
		do
			if attached Once_crc_generator as crc then
				if initial_current_digest.to_boolean then
					current_digest := initial_current_digest
				else
					initial_current_digest := current_digest
				end
				crc.set_checksum (current_digest)

				Class_link_list.add_to_checksum (crc, code_text)
				current_digest := crc.checksum
			end
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
		-- Is current object less than `other'?
		-- Called from {EIFFEL_CLASS_TABLE}.example_class_list
		-- Ensures consistent `current_digest' during call to `{LIBRARY_CLASS}.sink_source_substitutions'
		do
			if name ~ other.name then
				if source_parent_base ~ other.source_parent_base then
					Result := relative_source_path < other.relative_source_path
				else
				-- For example: imp_unix VS imp_mswin
					Result := source_parent_base < other.source_parent_base
				end
			else
				Result := name < other.name
			end
		end

feature -- Element change

	set_alias_name (a_name: ZSTRING)
		do
			alias_name := a_name
		end

	set_client_examples (class_list: ITERABLE [EIFFEL_CLASS])
		do
			do_nothing -- for example classes
		end

feature {NONE} -- Implementation

	class_begin_index: INTEGER
		do
			across Class_begin_strings as string until Result > 0 loop
				Result := code_text.substring_index (string.item, 1)
			end
		end

	source_encoding (source_text: STRING): NATURAL
		local
			utf: EL_UTF_CONVERTER
		do
			if utf.is_utf_8_file (source_text) then
				Result := Utf_8
			else
				Result := Latin_1
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

	new_code_text (raw_source: STRING; a_encoding: NATURAL): ZSTRING
		local
			utf: EL_UTF_CONVERTER
		do
			if a_encoding = Utf_8 then
				create Result.make_from_utf_8 (utf.bomless_utf_8 (raw_source))
			else
				create Result.make (raw_source.count)
				if Result.is_shareable_8 (raw_source) then
					Result.share_8 (raw_source)
				else
					Result.append_string_general (raw_source)
				end
			end
		end

	relative_ecf_html_path: ZSTRING
		do
			Result := library_ecf.html_index_path.relative_dot_path (relative_source_path)
		end

	set_class_use_set
		local
			analyzer: EIFFEL_CLASS_USE_ANALYZER
		do
			create analyzer.make (code_text)
			class_use_set := analyzer.class_name_set
		end

	sink_content (crc: like crc_generator)
		do
			crc.add_string (code_text)
			crc.add_string (relative_source_path)
		end

feature {NONE} -- Internal attributes

	config: PUBLISHER_CONFIGURATION

	initial_current_digest: NATURAL
		-- `current_digest' before modification by `sink_source_substitutions'

	library_ecf: EIFFEL_CONFIGURATION_FILE

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["description_elements",	 agent: like notes.description_elements do Result := notes.description_elements end],
				["note_fields",				 agent: like notes.field_list do Result := notes.field_list end],

				["has_description",			 agent: BOOLEAN_REF do Result := notes.has_description.to_reference end],
				["has_further_information", agent: BOOLEAN_REF do Result := has_further_information.to_reference end],
				["has_fields",					 agent: BOOLEAN_REF do Result := notes.has_fields.to_reference end],
				["is_library",					 agent: BOOLEAN_REF do Result := is_library.to_reference end],

				["notes_text",					 agent notes_text],
				["class_text",					 agent class_text],
				["further_information",		 agent further_information],
				["ecf_contents_path",		 agent relative_ecf_html_path],

				["name",							 agent: STRING do Result := name.string end],
				["name_as_lower",				 agent: STRING do Result := name.string.as_lower end],
				["html_path",					 agent: ZSTRING do Result := ecf_relative_html_path end],
				["favicon_markup_path",		 agent: ZSTRING do Result := config.templates.favicon_markup_path end],
				["top_dir",						 agent: ZSTRING do Result := Directory.relative_parent (relative_source_path.step_count - 1) end],

				["relative_dir",				 agent: DIR_PATH do Result := relative_source_path.parent end],
				["source_path",				 agent: FILE_PATH do Result := relative_source_path end]
			>>)
		end

end
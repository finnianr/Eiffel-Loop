note
	description: "[
		Edits note fields of an Eiffel class if the modified date has changed from note field date.
		Then increment revision and fill in author, copyright, contact, license and revision fields.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 10:04:10 GMT (Sunday 28th July 2013)"
	revision: "3"

class
	EIFFEL_NOTE_EDITOR

inherit
	EIFFEL_SOURCE_EDITING_PROCESSOR
		rename
			delimiting_pattern as note_section,
			make as make_proceessor
		redefine
			note_section, reset, set_source_text_from_line_source, edit_file
		end

	EL_MODULE_EVOLICITY

	EL_MODULE_DATE

	EL_MODULE_TEST

create
	make

feature {NONE} -- Initialization

	make (license_notes: LICENSE_NOTES)
			--
		do
			log.enter ("make")
			create default_values.make (<<
				[Field_author, license_notes.author],
				[Field_copyright, license_notes.copyright],
				[Field_contact, license_notes.contact],
				[Field_license, license_notes.license]
			>>)
			create standard_field_table.make_with_count (7)
			create non_standard_fields.make
			Evolicity.set_template (Template_name, Note_template)
			make_proceessor
			create last_date_time_stamp.make_from_epoch (0)
			log.exit
		end

feature -- Element change

	set_source_text_from_line_source (file: PLAIN_TEXT_FILE)
			--
		local
			date_field_stamp: DATE_TIME
			line: EL_ASTRING
			date_string, field_value: STRING
			date_found, revision_found: BOOLEAN
		do
			has_revision := False
 			source_file_path := file.path
 			create line.make_empty; create date_string.make_empty
 			last_time_stamp := file.date
 			create last_date_time_stamp.make_from_epoch (last_time_stamp)
 			from file.start until
 				(date_found and revision_found)
 					or across Class_declaration_keywords as keyword some line.starts_with (keyword.item) end
 					or file.end_of_file
 			loop
 				create line.make_from_unicode (file_line (file, is_utf8_source))
 				line.left_adjust
				if line.occurrences ('"') = 2 then
 					field_value := line.substring (line.index_of ('"', 1) + 1, line.last_index_of ('"', line.count) - 1).to_latin1
	 				if line.starts_with ("date:") then
	 					date_string := field_value
	 					date_found := True
	 				elseif line.starts_with ("revision:") and then field_value.is_integer then
	 					last_revision := field_value.to_integer
	 					revision_found := True
	 				end
 				end
 			end
 			if date_found then
 				create date_field_stamp.make_from_epoch (0)
				if date_string [1] /= '$' and then date_string.has_substring ("GMT") then
					date_string := date_string.substring (1, date_string.substring_index ("GMT", 1) - 2)
 					if not test.is_executing and then Date_time_code.is_date_time (date_string) then
	 					date_field_stamp := Date_time_code.create_date_time (date_string)
 					end
				end
 				has_revision := not date_field_stamp.is_equal (last_date_time_stamp)
 			end
			Precursor (file)
 		end

 	Class_declaration_keywords: ARRAY [STRING]
 		once
 			Result := << "class", "deferred", "frozen" >>
 		end

feature -- Status query

	has_revision: BOOLEAN

	is_eiffel_software: BOOLEAN

feature -- Basic operations

	edit_file
		local
			source_file: PLAIN_TEXT_FILE
		do
			if not source_text.has_substring (Eiffel_web_address) and then has_revision then
				Precursor
				create source_file.make (source_file_path.unicode)
				source_file.stamp (last_time_stamp)
			end
		end

feature {NONE} -- Pattern definitions

	note_section: EL_MATCH_ALL_IN_LIST_TP
			--
		local
			note_fields: EL_MATCH_TP1_UNTIL_TP2_MATCH_TP
		do
			note_fields := repeat_pattern_1_until_pattern_2 (
				one_of (<< white_space, note_field, eiffel_comment >>),
				class_declaration |to| agent on_class_declaration
			)
			note_fields.set_action_on_combined_repeated_match (agent on_note_fields)
			Result := all_of (<<
				one_of (<<
					string_literal ("note"),
					string_literal ("indexing")
				>>) |to| agent on_unmatched_text,
				note_fields
			>>)
		end

	note_field: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				c_identifier |to| agent on_field_name,
				character_literal (':'),
				maybe_white_space,
				one_of (<<
					unescaped_eiffel_string (agent on_verbatim_field_text),
					quoted_eiffel_string (agent on_field_text)
				>>)
			>> )
		end

feature {NONE} -- Parsing actions

	on_field_text (text: EL_STRING_VIEW)
			--
		do
			if last_field_name ~ Field_date then
				standard_field_table [Field_date] := String.template ("$S GMT ($S)").substituted (<<
					last_date_time_stamp.formatted_out (Date_time_format),
					Date.spelling_long (last_date_time_stamp.date, True)
				>>)
			elseif last_field_name ~ Field_revision then
				standard_field_table [Field_revision] := (last_revision + 1).out

			elseif Standard_fields.has (last_field_name) then
				standard_field_table [last_field_name] := text.view

			else
				non_standard_fields.extend (name_value_pair (last_field_name, text.view))
			end
		end

	on_verbatim_field_text (text: EL_STRING_VIEW)
			--
		local
			quoted_verbatim_text: STRING
		do
			quoted_verbatim_text := "[%N" + text.view + "%N%T]"
			if Standard_fields.has (last_field_name) then
				standard_field_table [last_field_name] := quoted_verbatim_text
			else
				non_standard_fields.extend (name_value_pair (last_field_name, quoted_verbatim_text))
			end
		end

	on_field_name (text: EL_STRING_VIEW)
			--
		do
			last_field_name := text
		end

	on_class_declaration (text: EL_STRING_VIEW)
			--
		local
			variable_context: EVOLICITY_CONTEXT_IMPL
		do
			across default_values as default_value loop
				standard_field_table.search (default_value.key)
				if standard_field_table.found then
					if Repositary_checkout_fields.has (default_value.key) then
						if standard_field_table.found_item.is_empty
							or is_place_holder_value (default_value.key, standard_field_table.found_item)
						then
							standard_field_table [default_value.key] := default_value.item
						end
					else
						standard_field_table [default_value.key] := default_value.item
					end
				else
					standard_field_table.extend (default_value.item, default_value.key)
				end
			end
			create variable_context.make_from_string_table (standard_field_table)
			variable_context.put_variable (non_standard_fields, "other_fields")
			put_string (Evolicity.merged_template (Template_name, variable_context))

			put_string (text)
		end

	on_note_fields (text: EL_STRING_VIEW)
			--
		do
			current_note_section := text
		end

feature {NONE} -- Implementation

	search_patterns: ARRAYED_LIST [EL_TEXTUAL_PATTERN]
		do
			create Result.make (0)
		end

	name_value_pair (name, value: STRING): EVOLICITY_CONTEXT_IMPL
			--
		do
			create Result.make
			Result.put_variable (name, "name")
			Result.put_variable (value, "value")
		end

	is_place_holder_value (variable, value: STRING): BOOLEAN
		do
			Result := ("$" + variable + "$") ~ value.as_lower
		end

	reset
			--
		do
			Precursor
			standard_field_table.wipe_out
			non_standard_fields.wipe_out
		end

	non_standard_fields: LINKED_LIST [EVOLICITY_CONTEXT]

	last_field_name: EL_ASTRING

	current_note_section: EL_ASTRING

	standard_field_table: EL_ASTRING_HASH_TABLE [EL_ASTRING]

	default_values: EL_ASTRING_HASH_TABLE [EL_ASTRING]

	last_time_stamp: INTEGER

	last_date_time_stamp: DATE_TIME

	last_revision: INTEGER

feature {NONE} -- Fields

	Field_author: EL_ASTRING
		once
			Result := "author"
		end

	Field_description: EL_ASTRING
		once
			Result := "description"
		end

	Field_copyright: EL_ASTRING
		once
			Result := "copyright"
		end

	Field_contact: EL_ASTRING
		once
			Result := "contact"
		end

	Field_license: EL_ASTRING
		once
			Result := "license"
		end

	Field_date: EL_ASTRING
		once
			Result := "date"
		end

	Field_revision: EL_ASTRING
		once
			Result := "revision"
		end

	Standard_fields: ARRAY [EL_ASTRING]
			--
		once
			Result := << Field_description, Field_author, Field_copyright, Field_contact, Field_license, Field_date, Field_revision >>
			Result.compare_objects
		end

feature -- Constants

	Date_time_code: DATE_TIME_CODE_STRING
		once
			create Result.make (Date_time_format)
		end

	Date_time_format: STRING = "yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss"

	Repositary_checkout_fields: ARRAY [EL_ASTRING]
		once
			Result := << Field_date, Field_revision >>
			Result.compare_objects
		end

	Template_name: EL_ASTRING
		once
			Result := "note"
		end

	Eiffel_web_address: STRING = "www.eiffel.com"

	Note_template: STRING = "{

	description: "$description"
	#foreach $field in $other_fields loop

	$field.name: "$field.value"
	#end

	author: "$author"
	copyright: "$copyright"
	contact: "$contact"
	
	license: "$license"
	date: "$date"
	revision: "$revision"


}"

	Class_declaration: EL_MATCH_ALL_IN_LIST_TP
			--
		once
			Result := all_of (<<
				optional (all_of (<< string_literal ("deferred"), white_space >>)),
				whole_word ("class")
			>>)
		end

end

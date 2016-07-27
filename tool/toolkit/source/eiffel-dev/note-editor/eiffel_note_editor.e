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
			delimiting_pattern as note_section
		redefine
			note_section, reset, set_source_text_from_line_source, edit
		end

	EL_MODULE_EVOLICITY_TEMPLATES

	EL_MODULE_DATE

	EL_MODULE_LOG

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

create
	make

feature {NONE} -- Initialization

	make (license_notes: LICENSE_NOTES)
			--
		do
			log.enter ("make")
			make_machine
			create default_values.make (<<
				[Field.author, license_notes.author],
				[Field.copyright, license_notes.copyright],
				[Field.contact, license_notes.contact],
				[Field.license, license_notes.license]
			>>)
			create standard_field_table.make_equal (7)
			create non_standard_fields.make
			Evolicity_templates.put (Template_name, Note_template)
			make_default
			log.exit
		end

feature -- Element change

	set_source_text_from_line_source (lines: EL_FILE_LINE_SOURCE)
			--
		local
			date_field_stamp: DATE_TIME; time_stamp: INTEGER
			date_string: STRING
		do
			has_revision := False
 			source_file_path := lines.file_path
 			last_time_stamp := lines.date

			last_revision := -1; create date_string.make_empty
			do_with_lines (agent find_date_and_revision (?, date_string), lines)
			date_field_stamp := new_date_field_stamp (date_string)

			time_stamp := date_field_stamp.relative_duration (Epoch_date).seconds_count.to_integer_32
			has_revision := last_revision = 0 or else (time_stamp - last_time_stamp).abs > 1
			Precursor (lines)
 		end

feature -- Status query

	has_revision: BOOLEAN

feature -- Basic operations

	edit
		local
			source_file: PLAIN_TEXT_FILE
		do
			if not source_text.has_substring (Eiffel_web_address) and then has_revision then
				Precursor
				create source_file.make_with_name (source_file_path)
				source_file.stamp (last_time_stamp + 1)
			end
		end

feature {NONE} -- Pattern definitions

	note_field: like all_of
			--
		do
			Result := all_of ( <<
				c_identifier |to| agent on_field_name,
				character_literal (':'),
				maybe_white_space,
				one_of (<<
					unescaped_manifest_string (agent on_verbatim_field_text),
					quoted_manifest_string (agent on_field_text)
				>>)
			>> )
		end

	note_section: like all_of
			--
		local
			note_fields: like repeat_p1_until_p2
		do
			note_fields := repeat_p1_until_p2 (
				one_of (<< white_space, note_field, comment >>),
				class_declaration |to| agent on_class_declaration
			)
			note_fields.set_action_combined_p1 (agent on_note_fields)
			Result := all_of (<<
				start_of_line,
				one_of (<< string_literal ("note"), string_literal ("indexing") >>) |to| agent on_unmatched_text,
				note_fields
			>>)
		end

feature {NONE} -- Parsing actions

	on_class_declaration (text: EL_STRING_VIEW)
			--
		local
			variable_context: EVOLICITY_CONTEXT_IMP
		do
			across default_values as default_value loop
				standard_field_table.search (default_value.key)
				if standard_field_table.found then
					if repository_checkout_fields.has (default_value.key) then
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
			put_string (Evolicity_templates.merged (Template_name, variable_context))

			put_string (text)
		end

	on_field_name (text: EL_STRING_VIEW)
			--
		do
			last_field_name := text
		end

	on_field_text (text: EL_STRING_VIEW)
			--
		do
			if last_field_name ~ Field.date then
				standard_field_table [Field.date] := Time_template #$ [
					last_time_stamp_as_date.formatted_out (Date_time_format),
					Date.formatted (last_time_stamp_as_date.date, {EL_DATE_FORMATS}.canonical)
				]
			elseif last_field_name ~ Field.revision then
				standard_field_table [Field.revision] := (last_revision + 1).out

			elseif Standard_fields.has (last_field_name) then
				standard_field_table [last_field_name] := text.to_string_8

			else
				non_standard_fields.extend (name_value_pair (last_field_name, text.to_string_8))
			end
		end

	on_note_fields (text: EL_STRING_VIEW)
			--
		do
			current_note_section := text
		end

	on_verbatim_field_text (text: EL_STRING_VIEW)
			--
		local
			quoted_verbatim_text: ZSTRING
		do
			quoted_verbatim_text := "[%N" + text.to_string_8 + "%N%T]"
			if Standard_fields.has (last_field_name) then
				standard_field_table [last_field_name] := quoted_verbatim_text
			else
				non_standard_fields.extend (name_value_pair (last_field_name, quoted_verbatim_text))
			end
		end

feature {NONE} -- Implementation

 	new_date_field_stamp (date_string: STRING): DATE_TIME
 		local
 			l_date: STRING; pos_gmt: INTEGER
 		do
			create Result.make_from_epoch (0)
			if not date_string.is_empty then
				pos_gmt := date_string.substring_index ("GMT", 1)
				if pos_gmt > 0 then
					l_date := date_string.substring (1, pos_gmt - 2)
 					if Date_time_code.is_date_time (l_date) then
 						Result := Date_time_code.create_date_time (l_date)
 					end
				end
			end
 		end

	is_place_holder_value (variable, value: STRING): BOOLEAN
		do
			Result := ("$" + variable + "$") ~ value.as_lower
		end

	name_value_pair (name, value: STRING): EVOLICITY_CONTEXT_IMP
			--
		do
			create Result.make
			Result.put_variable (name, "name")
			Result.put_variable (value, "value")
		end

	reset
			--
		do
			Precursor
			standard_field_table.wipe_out
			non_standard_fields.wipe_out
		end

	search_patterns: ARRAYED_LIST [EL_TEXT_PATTERN]
		do
			create Result.make (0)
		end

feature {NONE} -- Line states

	find_date_and_revision (line: ZSTRING; date_string: STRING)
		local
			field_name, value: ZSTRING
		do
			field_name := colon_name (line)
			if field_name ~ Field.date then
				date_string.share (colon_value (line))
			elseif field_name ~ Field.revision then
				value := colon_value (line)
				if value.is_integer then
					last_revision := value.to_integer
				else
					last_revision := 0
				end
			end
			if not date_string.is_empty and last_revision >= 0 then
				state := agent final
			end
		end

feature {NONE} -- Internal attributes

	current_note_section: ZSTRING

	default_values: EL_HASH_TABLE [ZSTRING, STRING]

	last_field_name: STRING

	last_revision: INTEGER

	last_time_stamp: INTEGER

	last_time_stamp_as_date: DATE_TIME
		do
			create Result.make_from_epoch (last_time_stamp)
		end

	non_standard_fields: LINKED_LIST [EVOLICITY_CONTEXT]

	standard_field_table: EL_HASH_TABLE [ZSTRING, STRING]

feature {NONE} -- Fields

	Field: TUPLE [author, date, description, copyright, contact, license, revision: STRING]
		do
			create Result
			Result := ["author", "date", "description", "copyright", "contact", "license", "revision"]
		end

	Standard_fields: EL_STRING_8_LIST
			--
		once
			create Result.make_from_tuple (Field)
			Result.compare_objects
		end

feature -- Constants

	Class_declaration: EL_MATCH_ALL_IN_LIST_TP
			--
		once
			Result := all_of (<<
				optional (all_of (<< string_literal ("deferred"), white_space >>)),
				whole_word ("class")
			>>)
		end

 	Class_declaration_keywords: ARRAY [ZSTRING]
 		once
 			Result := << "class", "deferred", "frozen" >>
 		end

	Date_time_code: DATE_TIME_CODE_STRING
		once
			create Result.make (Date_time_format)
		end

	Date_time_format: STRING = "yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss"

	Eiffel_web_address: STRING = "www.eiffel.com"

	Epoch_date: DATE_TIME
		once
			create Result.make_from_epoch (0)
		end

 	Field_marker: TUPLE [date, revision: ZSTRING]
 		once
 			create Result
 			Result.date := "date:"
 			Result.revision := "revision:"
 		end

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

	Template_name: ZSTRING
		once
			Result := "note"
		end

	Time_template: ZSTRING
		once
			Result := "%S GMT (%S)"
		end

	repository_checkout_fields: ARRAY [ZSTRING]
		once
			Result := << Field.date, Field.revision >>
			Result.compare_objects
		end

end

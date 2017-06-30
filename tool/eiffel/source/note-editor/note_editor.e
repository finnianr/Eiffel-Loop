note
	description: "[
		Edits note fields of an Eiffel class if the modified date has changed from note field date.
		("changed" means a difference of more than one second)
		If the class has changed then increment revision and fill in author, copyright, contact, 
		license and revision fields.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 11:27:11 GMT (Thursday 29th June 2017)"
	revision: "5"

class
	NOTE_EDITOR

inherit
	EL_EIFFEL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR
		redefine
			edit
		end

	EIFFEL_CONSTANTS

	EL_STRING_CONSTANTS

	EL_MODULE_DATE

	EL_MODULE_DIRECTORY

	EL_MODULE_TIME

	EL_MODULE_COLON_FIELD

create
	make

feature {NONE} -- Initialization

	make (license_notes: LICENSE_NOTES)
			--
		do
			create default_values.make (<<
				[Field.author, license_notes.author],
				[Field.copyright, license_notes.copyright],
				[Field.contact, license_notes.contact],
				[Field.license, license_notes.license]
			>>)
			create standard_fields.make_equal (7)
			make_default
		end

feature -- Element change

	reset
		do
			fill_standard_fields
			output_lines.wipe_out
			has_revision := False
		end

feature -- Basic operations

	edit
		local
			time_stamp: INTEGER; source_file: PLAIN_TEXT_FILE
		do
			reset
			if not is_override_class then
				do_with_lines (agent read_standard_fields, input_lines)

	 			last_time_stamp := input_lines.date
				time_stamp := Time.unix_date_time (standard_field_date)
				last_revision := standard_field_revision
				has_revision := last_revision = 0 or else (time_stamp - last_time_stamp).abs > 1

				if has_revision then
					put_standard_field_lines
					Precursor
					create source_file.make_with_name (file_path)
					source_file.stamp (last_time_stamp + 1)
				end
			end
		end

feature -- Status query

	has_revision: BOOLEAN

feature {NONE} -- Line states

	find_class_definition (line: ZSTRING)
		do
			if is_class_definition_start (line) then
				output_lines.extend (line)
				state := agent put_class_definition_lines
			end
		end

	put_class_definition_lines (line: ZSTRING)
		do
			output_lines.extend (line)
		end

	read_standard_fields (line: ZSTRING)
		local
			field_name: STRING
		do
			field_name := colon_name (line)
			if standard_fields.has (field_name) then
				standard_fields [field_name] := Colon_field.value (line)

			elseif is_class_definition_start (line) then
				state := final
			else
				output_lines.extend (line)
			end
		end

feature {NONE} -- Implementation

	colon_name (line: ZSTRING): ZSTRING
		do
			if line.leading_occurrences ('%T') = 1 then
				Result := Colon_field.name (line)
			else
				create Result.make_empty
			end
		end

	fill_standard_fields
		do
			standard_fields.wipe_out
			across Field_names as name loop
				standard_fields.extend (create {ZSTRING}.make_empty, name.item)
			end
		end

	formatted_time_stamp: ZSTRING
		local
			last_date_time: DATE_TIME
		do
			create last_date_time.make_from_epoch (last_time_stamp)
			Result := Time_template #$ [
				last_date_time.formatted_out (Date_time_format),
				Date.formatted (last_date_time.date, {EL_DATE_FORMATS}.canonical)
			]
		end

	initial_state: PROCEDURE [ZSTRING]
		do
			Result := agent find_class_definition
		end

	is_class_definition_start (line: ZSTRING): BOOLEAN
		do
			Result := across Class_declaration_keywords as keyword some line.starts_with (keyword.item) end
		end

	is_override_class: BOOLEAN
		do
			Result := file_path.has_step (Override_step)
		end

	put_standard_field_lines
		local
			value: ZSTRING; l_name: STRING
		do
			from output_lines.finish until not output_lines.item.is_empty loop
				output_lines.remove; output_lines.finish
			end
			put_empty_line

			across Field_names as name loop
				l_name := name.item
				if name.item ~ Field.date then
					value := formatted_time_stamp
				elseif name.item ~ Field.revision then
					value := (last_revision + 1).max (1).out
				else
					value := default_values [name.item]
				end
				output_lines.extend (Field_line_template #$ [name.item, value])
				if name.cursor_index = 3 then
					put_empty_line
				end
			end
			put_empty_line
		end

	put_empty_line
		do
			output_lines.extend (Empty_string)
		end

	standard_field_date: DATE_TIME
 		local
 			l_date: STRING; pos_gmt: INTEGER; date_string: STRING
 		do
			create Result.make_from_epoch (0)
			standard_fields.search (Field.date)
			if standard_fields.found then
				date_string := standard_fields.found_item
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
 		end

	standard_field_revision: INTEGER
		local
			value: ZSTRING
		do
			Result := -1
			standard_fields.search (Field.revision)
			if standard_fields.found then
				value := standard_fields.found_item
				if value.is_integer then
					Result := value.to_integer
				end
			end
		end

feature {NONE} -- Internal attributes

	default_values: EL_HASH_TABLE [ZSTRING, STRING]

	last_revision: INTEGER

	last_time_stamp: INTEGER

	standard_fields: EL_HASH_TABLE [ZSTRING, STRING]

feature {NONE} -- Fields

	Override_step: ZSTRING
		once
			Result := "override"
		end

feature -- Constants

	Field_line_template: ZSTRING
		once
			Result := "%T%S: %"%S%""
		end

	Time_template: ZSTRING
		once
			Result := "%S GMT (%S)"
		end

end

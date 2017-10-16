note
	description: "Summary description for {CLASS_NOTES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 17:09:55 GMT (Thursday 12th October 2017)"
	revision: "1"

class
	CLASS_NOTES

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	EL_MODULE_COLON_FIELD

	EL_MODULE_DATE

	EL_MODULE_TIME

	NOTE_CONSTANTS

	EL_EIFFEL_KEYWORDS

	EL_STRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (class_lines: EL_FILE_LINE_SOURCE; default_values: EL_HASH_TABLE [ZSTRING, STRING])
		do
			make_machine
			create original_lines.make_empty
			create fields.make (10)
 			last_time_stamp := class_lines.date
			do_with_lines (agent find_field, class_lines)

			-- Add default values for missing fields
			across default_values as value loop
				fields.find (value.key)
				if fields.found then
					if fields.item.text.is_empty then
						fields.item.set_text (value.item)
					end
				else
					fields.extend (create {NOTE_FIELD}.make (value.key, value.item))
				end
			end
		end

feature -- Access

	field_date: DATE_TIME
 		local
 			l_date: STRING; pos_gmt: INTEGER; date_string: STRING
 		do
			create Result.make_from_epoch (0)
			fields.find (Field.date)
			if fields.found then
				date_string := fields.item.text
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

	field_revision: INTEGER
		local
			value: ZSTRING
		do
			Result := -1
			fields.find (Field.revision)
			if fields.found then
				value := fields.item.text
				if value.is_integer then
					Result := value.to_integer
				end
			end
		end

	last_time_stamp: INTEGER

	original_lines: EL_ZSTRING_LIST

	revised_lines: EL_ZSTRING_LIST
		do
			create Result.make (10)
			Result.extend ("note")
			across << initial_field_names.to_array, Author_fields, License_fields >> as group loop
				extend_field_list (group.item, Result)
			end
			across Result as line loop
				if line.cursor_index > 1 and then not line.item.is_empty then
					line.item.prepend (Tab)
				end
			end
		end

	time_stamp: INTEGER
		do
			Result := Time.unix_date_time (field_date)
		end

feature -- Status query

	is_revision: BOOLEAN

feature -- Element change

	check_revision
		local
			last_revision: INTEGER
		do
			last_revision := field_revision
			if last_revision = 0 or else (time_stamp - last_time_stamp).abs > 1 then
				fields.set_field (Field.date, formatted_time_stamp)
				fields.set_field (Field.revision, (last_revision + 1).max (1).out)
				is_revision := true
			end
		end

feature {NONE} -- Line states

	find_field (line: ZSTRING)
		local
			name: STRING; value: ZSTRING
			verbatim_field: VERBATIM_NOTE_FIELD
		do
			if is_class_definition_start (line) then
				state := final
			else
				original_lines.extend (line)
				if is_field (line) then
					name := Colon_field.name (line); value := Colon_field.value (line)
					if value.starts_with (Verbatim_string_start) then
						create verbatim_field.make (name)
						fields.extend (verbatim_field)
						state := agent find_verbatim_string_end (?, verbatim_field)
					else
						fields.extend (create {NOTE_FIELD}.make (name, value))
					end
				end
			end
		end

	find_verbatim_string_end (line: ZSTRING; verbatim_field: VERBATIM_NOTE_FIELD)
		do
			original_lines.extend (line)
			if line.ends_with (Verbatim_string_end) then
				state := agent find_field
			else
				if line.starts_with (Tab) then
					verbatim_field.append_text (line.substring_end (2))
				else
					verbatim_field.append_text (line)
				end
			end
		end

feature {NONE} -- Implementation

	extend_field_list (name_group: ARRAY [STRING]; list: EL_ZSTRING_LIST)
		local
			value: ZSTRING
		do
			across name_group as name loop
				fields.find (name.item)
				if fields.found then
					list.append (fields.item.lines)
				end
			end
			list.extend (Empty_string)
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

	initial_field_names: ARRAYED_LIST [STRING]
		do
			create Result.make (3)
			from fields.start until fields.after or else fields.item.name ~ Field.author loop
				Result.extend (fields.item.name)
				fields.forth
			end
		end

	is_class_definition_start (line: ZSTRING): BOOLEAN
		do
			Result := Class_declaration_keywords.there_exists (agent line.starts_with)
		end

	is_field (line: ZSTRING): BOOLEAN
		local
			name: ZSTRING
		do
			name := line.substring_between (Tab, Quote, 1)
			name.right_adjust
			Result := name.count > 3 and then name [name.count] = ':'
		end

feature {NONE} -- Internal attributes

	fields: NOTE_FIELD_LIST

feature {NONE} -- Constants

	Quote: ZSTRING
		once
			Result := "%""
		end

	Tab: ZSTRING
		once
			Result := "%T"
		end

	Time_template: ZSTRING
		once
			Result := "%S GMT (%S)"
		end

end

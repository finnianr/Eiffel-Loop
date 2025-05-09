note
	description: "Class note editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-09 10:30:21 GMT (Friday 9th May 2025)"
	revision: "21"

class
	CLASS_NOTE_EDITOR

inherit
	CLASS_NOTES
		rename
			make_with_line_source as make_notes
		end

	EL_MODULE_DATE; EL_MODULE_DATE_TIME

	EL_ZSTRING_CONSTANTS

	EL_SHARED_DATE_FORMAT

create
	make

feature {NONE} -- Initialization

	make (class_lines: EL_PLAIN_TEXT_LINE_SOURCE; default_values: EL_HASH_TABLE [ZSTRING, IMMUTABLE_STRING_8])
		do
			make_notes (class_lines)

			create updated_fields.make (0)
			last_time_stamp := class_lines.date

			-- Add default values for missing fields
			if default_values.has_key (Field.author) and then is_owned (default_values.found_item) then
				across default_values as value loop
					fields.find (value.key)
					if fields.found then
						if fields.item.text /~ value.item then
							fields.item.set_text (value.item)
							updated_fields.extend (value.key)
						end
					else
						fields.extend (create {NOTE_FIELD}.make (value.key, value.item))
					end
				end
			end
		end

feature -- Access

	field_date: NOTE_DATE_TIME
		do
			fields.find (Field.date)
			if fields.found and then fields.item.text.has_substring (Date_time.Zone.GMT) then
				create Result.make (fields.item.text)
			else
				create Result.make_default
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

	revised_lines: EL_ZSTRING_LIST
		do
			create Result.make (10)
			Result.extend ("note")
			across << initial_field_names.to_array, Author_fields, License_fields >> as group loop
				extend_field_list (group.item, Result)
			end
			across Result as line loop
				if line.cursor_index > 1 and then not line.item.is_empty then
					line.item.prepend_character ('%T')
				end
			end
		end

	updated_fields: EL_STRING_8_LIST

feature -- Status query

	is_revision: BOOLEAN

	is_owned (author_name: ZSTRING): BOOLEAN
		-- `True' if class not authored by another person
		do
			fields.find (Field.author)
			if fields.found and then fields.item.text.count > 0 then
				Result := author_name ~ fields.item.text
			else
				Result := True
			end
		end

feature -- Element change

	check_revision
		local
			last_revision: INTEGER
		do
			last_revision := field_revision
			if last_revision = 0 or else (field_date.time_stamp - last_time_stamp).abs > 1 then
				fields.set_field (Field.date, formatted_time_stamp)
				fields.set_field (Field.revision, (last_revision + 1).max (1).out)
				is_revision := true
			end
		end

feature {NONE} -- Implementation

	extend_field_list (name_group: ARRAY [IMMUTABLE_STRING_8]; list: EL_ZSTRING_LIST)
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
				Date.formatted (last_date_time.date, Date_format.canonical)
			]
		end

	initial_field_names: ARRAYED_LIST [IMMUTABLE_STRING_8]
		do
			create Result.make (5)
			across fields as list until list.item.name ~ Field.author loop
				Result.extend (list.item.name)
			end
		end

feature {NONE} -- Constants

	Time_template: ZSTRING
		once
			Result := "%S GMT (%S)"
		end

end
note
	description: "Class notes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-19 16:56:04 GMT (Sunday 19th December 2021)"
	revision: "5"

class
	CLASS_NOTES

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	NOTE_CONSTANTS

create
	make_with_line_source, make_with_lines

feature {NONE} -- Initialization

	make_with_line_source (lines: EL_PLAIN_TEXT_LINE_SOURCE)
		do
			make_with_lines (lines.file_path, lines)
		end

	make_with_lines (a_file_path: EL_FILE_PATH; lines: LINEAR [ZSTRING])
		do
			make_machine
			file_path := a_file_path
			class_name := a_file_path.base_sans_extension
			class_name.to_upper
			create fields.make (10)
			create original_lines.make_empty
			do_with_lines (agent find_field, lines)
		end

feature -- Access

	class_name: ZSTRING

	fields: NOTE_FIELD_LIST

	file_path: EL_FILE_PATH

	original_lines: EL_ZSTRING_LIST

feature {NONE} -- Line states

	find_field (line: ZSTRING)
		local
			name: STRING; value: ZSTRING; verbatim_field: VERBATIM_NOTE_FIELD
			f: EL_COLON_FIELD_ROUTINES; eiffel: EL_EIFFEL_SOURCE_ROUTINES
		do
			if eiffel.is_class_definition_start (line) then
				state := final
			else
				original_lines.extend (line)
				if is_field (line) then
					name := f.name (line); value := f.value (line)
					if value.starts_with (Verbatim_string_start) then
						create verbatim_field.make (name)
						fields.extend (verbatim_field)
						state := agent find_verbatim_string_end (?, verbatim_field)
					else
						if name ~ Description
							and then (value.is_empty or Description_defaults.there_exists (agent value.starts_with))
						then
							value := default_description
						end
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

	Quote: ZSTRING
		once
			Result := "%""
		end

	default_description: ZSTRING
		local
			words: EL_ZSTRING_LIST
		do
			create words.make_split (class_name.as_lower, '_')
			words.start
			if words.item ~ EL then
				words.remove
			end
			words.start
			if not words.off then
				words.replace (words.item.as_proper_case)
			end
			Result := words.joined_words
		end

	is_field (line: ZSTRING): BOOLEAN
		local
			name: ZSTRING
		do
			name := line.substring_between (Tab, Quote, 1)
			name.right_adjust
			Result := name.count > 3 and then name [name.count] = ':'
		end

feature {NONE} -- Constants

	Description: STRING = "description"

	Description_defaults: ARRAY [ZSTRING]
		once
			Result := << "Summary description for", "Objects that" >>
		end

	EL: ZSTRING
		once
			Result := "el"
		end

	Tab: ZSTRING
		once
			Result := "%T"
		end

end
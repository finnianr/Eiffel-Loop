note
	description: "Class notes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-09 10:30:21 GMT (Friday 9th May 2025)"
	revision: "17"

class
	CLASS_NOTES

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

	NOTE_CONSTANTS

	EL_MODULE_NAMING

create
	make_with_line_source, make_with_lines

feature {NONE} -- Initialization

	make_with_line_source (lines: EL_PLAIN_TEXT_LINE_SOURCE)
		do
			make_with_lines (lines.file_path, lines)
		end

	make_with_lines (a_file_path: FILE_PATH; lines: LINEAR [ZSTRING])
		do
			make_machine
			file_path := a_file_path
			class_name := a_file_path.base_name
			class_name.to_upper
			create fields.make (10)
			create original_lines.make_empty
			do_with_lines (agent find_field, lines)
		end

feature -- Access

	class_name: STRING

	fields: NOTE_FIELD_LIST

	file_path: FILE_PATH

	original_lines: EL_ZSTRING_LIST

feature {NONE} -- Line states

	find_field (line: ZSTRING)
		local
			name, value: ZSTRING; verbatim_field: VERBATIM_NOTE_FIELD
			f: EL_COLON_FIELD_ROUTINES; eiffel: EL_EIFFEL_SOURCE_ROUTINES
		do
			if eiffel.is_class_definition_start (line) then
				state := final
			else
				original_lines.extend (line)
				if is_field (line) then
					name := f.name (line); value := f.value (line)
					if value.starts_with (Verbatim_string_start) then
						create verbatim_field.make (name.to_shared_immutable_8)
						fields.extend (verbatim_field)
						state := agent find_verbatim_string_end (?, verbatim_field)
					else
						if name ~ Description
							and then (value.is_empty or across Description_defaults as l some value.starts_with (l.item) end)
						then
							value := default_description
						end
						fields.extend (create {NOTE_FIELD}.make (name.to_shared_immutable_8, value))
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
				if line.starts_with_character ('%T') then
					verbatim_field.append_text (line.substring_end (2))
				else
					verbatim_field.append_text (line)
				end
			end
		end

feature {NONE} -- Implementation

	default_description: ZSTRING
		local
			words: EL_CLASS_NAME_WORDS
		do
			create words.make_from_name (class_name)
			words.remove_words (excluded_words)
			Result := words.description
		end

	is_field (line: ZSTRING): BOOLEAN
		local
			name: ZSTRING
		do
			name := line.substring_between_characters ('%T', '"', 1)
			name.right_adjust
			Result := name.count > 3 and then name [name.count] = ':'
		end

feature {NONE} -- Constants

	Description: STRING = "description"

	Description_defaults: ARRAY [ZSTRING]
		once
			Result := << "Summary description for", "Objects that" >>
		end

feature {NONE} -- Constants

	Excluded_words: EL_STRING_8_LIST
		once
			Result := "EL, IMP, I"
		end
end
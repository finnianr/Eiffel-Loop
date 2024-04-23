note
	description: "Document node string with specific encoding `encoding_name'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-22 15:01:20 GMT (Monday 22nd April 2024)"
	revision: "44"

class
	EL_DOCUMENT_NODE_STRING

inherit
	EL_UTF_8_STRING
		rename
			is_empty as is_raw_empty,
			make as make_with_capacity
		export
			{NONE} all
			{EL_DOCUMENT_CLIENT} set_from_c, set_from_c_with_count, right_adjust

			{ANY} count, wipe_out, share, set_from_general, unescape,
					-- Basic operations
					set, set_8, set_32, append_adjusted_to,
					-- Element change
					append, append_character, append_count_from_c, append_substring,
					prepend, prepend_character,
					-- Status query
					has, has_substring, starts_with, raw_string, raw_string_8, raw_string_32,
					is_boolean, is_double, is_integer, is_real, is_valid_as_string_8, is_raw_empty,
					same_string_general
		redefine
			append_to_string, append_to_string_8, append_to_string_32,
			as_string_32, to_string_32, as_string_8, to_boolean, to_string_8, to_string,
			unicode_count
		end

	EL_READABLE
		rename
			read_character_8 as to_character_8,
			read_character_32 as to_character_32,
			read_integer_8 as to_integer_8,
			read_integer_16 as to_integer_16,
			read_integer_32 as to_integer,
			read_integer_64 as to_integer_64,
			read_natural_8 as to_natural_8,
			read_natural_16 as to_natural_16,
			read_natural_32 as to_natural,
			read_natural_64 as to_natural_64,
			read_real_32 as to_real,
			read_real_64 as to_double,
			read_string as to_string,
			read_string_8 as to_string_8,
			read_string_32 as to_string_32,
			read_boolean as to_boolean,
			read_pointer as to_pointer
		undefine
			copy, is_equal, out
		end

	EL_STRING_NODE
		rename
			as_string as adjusted,
			as_string_8 as adjusted_8,
			as_string_32 as adjusted_32
		undefine
			copy, is_equal, out
		end

	EL_ENCODEABLE_AS_TEXT
		rename
			encoding as encoding_code,
			make as make_with_encoding,
			make_default as make_encodeable
		export
			{NONE} all
			{EL_DOCUMENT_CLIENT} set_encoding_from_other, set_encoding, set_latin_encoding, set_utf_encoding
		undefine
			copy, is_equal, out
		end

	EL_XPATH_NODE_CONSTANTS

	EL_SHARED_ENCODINGS; EL_SHARED_ZSTRING_BUFFER_SCOPES



create
	make, make_default

convert
	to_boolean: {BOOLEAN}, to_real: {REAL_32},
	to_integer: {INTEGER}, to_integer_64: {INTEGER_64},
	to_natural: {NATURAL}, to_natural_64: {NATURAL_64},
	to_string_32: {STRING_32}, to_string: {ZSTRING}

feature {NONE} -- Initialization

	make (a_document_dir: DIR_PATH)
		do
			document_dir := a_document_dir
			make_empty; make_encodeable
			create raw_name.make (0)
		end

	make_default
		do
			make (create {DIR_PATH})
		end

feature -- Access

	code_value_16 (current_code: NATURAL_16; enumeration: EL_ENUMERATION_NATURAL_16): NATURAL_16
		-- enumeration value for current node name or `current_code' if name is invalid
		do
			if enumeration.has_name (as_enumeration_name) then
				Result := enumeration.found_value
			else
				Result := current_code
			end
		end

	code_value_8 (current_code: NATURAL_8; enumeration: EL_ENUMERATION_NATURAL_8): NATURAL_8
		-- enumeration value for current node name or `current_code' if name is invalid
		do
			if enumeration.has_name (as_enumeration_name) then
				Result := enumeration.found_value
			else
				Result := current_code
			end
		end

	document_dir: DIR_PATH

	name: ZSTRING
		do
			if encoded_as_utf (8) then
				create Result.make_from_utf_8 (raw_name)
			else
				create Result.make_from_general (raw_name)
			end
		end

	once_name: ZSTRING
		do
			Result := Name_buffer.empty
			if encoded_as_utf (8) then
				Result.append_utf_8 (raw_name)
			else
				Result.append_string_general (raw_name)
			end
		end

	type: INTEGER
		-- Node type id

feature -- Access

	xpath_name (keep_ref: BOOLEAN): ZSTRING
		--
		do
			Result := Name_buffer.empty
			extend_xpath (Result)
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- Measurement

	unicode_count: INTEGER
		do
			if encoded_as_utf (8) then
				Result := Precursor
			else
				Result := count
			end
		end

feature -- Status query

	is_empty: BOOLEAN
			--
		do
			Result := leading_white_count = count
		end

	same_as (a_string: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := adjusted (False).same_string_general (a_string)
		end

	same_as_32 (str_32: READABLE_STRING_32): BOOLEAN
		do
			Result := adjusted_32 (False).same_string (str_32)
		end

	same_as_8 (str_8: READABLE_STRING_8): BOOLEAN
		do
			Result := adjusted_8 (False).same_string (str_8)
		end

feature -- String conversion

	to_boolean: BOOLEAN
		do
			Result := is_boolean and then count = 4
		end

	to_string: ZSTRING
		do
			Result := adjusted (True)
		end

	to_string_32, as_string_32: STRING_32
		do
			Result := adjusted_32 (True)
		end

	to_string_8, as_string_8: STRING_8
		do
			Result := adjusted_8 (True)
		end

feature -- Conversion

	to_adjusted_lines: ZSTRING
		-- left and right adjusted list of line strings with line breaks
		do
			Result := new_adjusted_lines ('%N')
		end

	to_canonically_spaced: ZSTRING
		-- left and right adjusted list of lines merged as one line
		do
			Result := new_adjusted_lines (' ')
		end

	to_character_32: CHARACTER_32
		local
			str_32: STRING_32; i, l_count: INTEGER; c: CHARACTER_32
		do
			str_32 := raw_string_32 (False)
			if str_32.count = 1 then
				Result := str_32 [1]
			else
				l_count := str_32.count
				from i := 1 until Result /= '%U' or else i > l_count loop
					c := str_32 [i]
					if not c.is_space then
						Result := c
					end
					i := i + 1
				end
			end
		end

	to_character_8: CHARACTER
		local
			nb, i: INTEGER; l_area: like area; c: CHARACTER
		do
			l_area := area
			if count = 1 then
				Result := l_area [0]
			else
				nb := count
				from i := 0 until Result /= '%U' or else i = nb loop
					c := l_area [i]
					if not c.is_space then
						Result := c
					end
					i := i + 1
				end
			end
		end

	to_expanded_dir_path: DIR_PATH
		do
			create Result.make_expanded (adjusted (False))
-- 		There are many cases where we may want to have a non-absolute path			
--			if not Result.is_absolute and then not document_dir.is_empty then
--				Result := document_dir #+ Result
--			end
		end

	to_expanded_file_path: FILE_PATH
		do
			create Result.make_expanded (adjusted (False))
			if not Result.is_absolute and then not document_dir.is_empty then
				Result := document_dir.plus (Result)
			end
		end

	to_pointer: POINTER
		do
		end

feature -- Element change

	set_type (a_type: INTEGER)
		do
			type := a_type
		end

feature -- Basic operations

	extend_xpath (xpath: STRING)
			--
		do
			inspect type
				when Type_element then
					xpath.append (raw_name)

				when Type_text, Type_comment then
					xpath.append (Node_name [type])

				when Type_processing_instruction then
					xpath.append (Node_name [Type_processing_instruction])
					xpath.append (once "('")
					xpath.append (raw_name)
					xpath.append (once "')")

			else
				xpath.append (raw_name)
			end
		end

feature {NONE} -- Implementation

	append_to_string (zstr: ZSTRING; str_8: READABLE_STRING_8)
		do
			zstr.append_encoded (str_8, encoding_code)
		end

	append_to_string_32 (str_32: STRING_32; str_8: READABLE_STRING_8)
		do
			if encoded_as_utf (8) then
				Precursor (str_32, str_8)

			elseif encoded_as_latin (1) then
				str_32.append_string_general (str_8)

			elseif attached as_encoding as encoding then
				encoding.convert_to (Encodings.Unicode, str_8)

				if encoding.last_conversion_successful then
					check
						no_lost_data: not encoding.last_conversion_lost_data
					end
					str_32.append_string_general (encoding.last_converted_string)
				else
					str_32.append_string_general (str_8)
				end
			end
		end

	append_to_string_8 (target: STRING; str_8: READABLE_STRING_8)
		do
			if encoded_as_utf (8) then
				Precursor (target, str_8)

			elseif encoded_as_latin (1) then
				target.append (str_8)

			elseif attached as_encoding as encoding then
				encoding.convert_to (Encodings.Latin_1, str_8)
				if encoding.last_conversion_successful then
					check
						no_lost_data: not encoding.last_conversion_lost_data
					end
					target.append (encoding.last_converted_string_8)
				else
					target.append (str_8)
				end
			end
		end

	as_enumeration_name: STRING
		do
			if is_empty then
				Result := Current
			elseif is_ascii and then not (item (1).is_space or item (count).is_space) then
				Result := Current
			else
				Result := adjusted_8 (False)
			end
		end

	new_adjusted_lines (separator: CHARACTER_32): ZSTRING
		-- left and right adjusted list of line strings
		local
			line_split: EL_SPLIT_ZSTRING_ON_CHARACTER
		do
			create line_split.make_adjusted (adjusted (False), '%N', {EL_SIDE}.Both)
			create Result.make (line_split.target.count)
			across line_split as list loop
				if list.cursor_index > 1 then
					Result.append_character (separator)
				end
				list.append_item_to (Result)
			end
		end

feature {EL_DOCUMENT_CLIENT} -- Internal attributes

	raw_name: EL_UTF_8_STRING


feature {NONE} -- Constants

	Name_buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

end
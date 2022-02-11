note
	description: "Document node string with specific encoding `encoding_name'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-11 10:24:40 GMT (Friday 11th February 2022)"
	revision: "22"

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

			{ANY} count, wipe_out, share, set_from_general, append_adjusted_to, unescape,
					-- Element change
					append, append_character, append_count_from_c, append_substring, prepend,
					-- Status query
					has, has_substring, starts_with,
					is_boolean, is_double, is_integer, is_real, is_valid_as_string_8, is_raw_empty
		redefine
			adjusted, adjusted_8, adjusted_32,
			as_string_32, to_string_32, as_string_8, to_string_8, to_string,
			raw_string, raw_string_8, raw_string_32
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
			make as make_with_encoding,
			make_default as make_encodeable,
			encoding as encoding_code
		export
			{NONE} all
			{EL_DOCUMENT_CLIENT} set_encoding_from_other
		undefine
			copy, is_equal, out
		end

	EL_XPATH_CONSTANTS
		undefine
			copy, is_equal, out
		end

	EL_SHARED_ENCODINGS

create
	make, make_default

convert
	to_boolean: {BOOLEAN},
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
			Result := buffer.empty
			if encoded_as_utf (8) then
				Result.append_utf_8 (raw_name)
			else
				Result.append_string_general (raw_name)
			end
		end

	type: INTEGER
		-- Node type id

	xpath_name (keep_ref: BOOLEAN): ZSTRING
			--
		do
			Result := buffer.empty
			inspect type
				when Node_type_element then
					if encoded_as_utf (8) then
						Result.append_utf_8 (raw_name)
					else
						Result.append_string_general (raw_name)
					end

				when Node_type_text then
					Result.append_raw_string_8 (Node_text)

				when Node_type_comment then
					Result.append_raw_string_8 (Node_comment)

				when Node_type_processing_instruction then
					Result.append_raw_string_8 (Node_processing_instruction)
					if encoded_as_utf (8) then
						Result.append_utf_8 (raw_name)
					else
						Result.append_string_general (raw_name)
					end
					Result.append_raw_string_8 (Node_processing_instruction_end)

			else
				Result.append_string_general (raw_name)
			end
			if keep_ref then
				Result := Result.twin
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
			Result := adjusted (False).same_string (a_string)
		end

feature -- String conversion

	adjusted (keep_ref: BOOLEAN): ZSTRING
		-- string with adjusted whitespace
		do
			if encoded_as_utf (8) then
				Result := Precursor (keep_ref)
			else
				Result := buffer.empty
				Result.append_encodeable (buffer_8.adjusted (Current), Current)
				if keep_ref then
					Result := Result.twin
				end
			end
		end

	adjusted_32 (keep_ref: BOOLEAN): STRING_32
		do
			if encoded_as_utf (8) then
				Result := Precursor (keep_ref)
			else
				Result := buffer_32.empty
				if attached buffer_8.adjusted (Current) as str_8 then
					if encoded_as_latin (1) then
						Result.append_string_general (str_8)

					elseif attached as_encoding as encoding then
						encoding.convert_to (Encodings.Unicode, str_8)
						if encoding.last_conversion_successful then
							check
								no_lost_data: not encoding.last_conversion_lost_data
							end
							Result.append_string_general (encoding.last_converted_string)
						else
							Result.append_string_general (str_8)
						end
					end
				end
				if keep_ref then
					Result := Result.twin
				end
			end
		end

	adjusted_8 (keep_ref: BOOLEAN): STRING_8
		-- string with adjusted whitespace
		local
			l_buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			if encoded_as_utf (8) then
				Result := Precursor (keep_ref)
			else
				if attached l_buffer.adjusted (Current) as str_8 then
					if encoded_as_latin (1) then
						Result := str_8

					elseif attached as_encoding as encoding then
						encoding.convert_to (Encodings.Latin_1, str_8)
						if encoding.last_conversion_successful then
							check
								no_lost_data: not encoding.last_conversion_lost_data
							end
							Result.append (encoding.last_converted_string_8)
						else
							Result := str_8
						end
					end
				end
				if keep_ref then
					Result := Result.twin
				end
			end
		end

	raw_string (keep_ref: BOOLEAN): ZSTRING
		-- string with unadjusted whitespace
		do
			if encoded_as_utf (8) then
				Result := Precursor (keep_ref)
			else
				Result := buffer.copied_general (Current)
			end
		end

	raw_string_32 (keep_ref: BOOLEAN): STRING_32
		-- string with unadjusted whitespace
		local
			l_buffer: EL_STRING_32_BUFFER_ROUTINES
		do
			if encoded_as_utf (8) then
				Result := Precursor (keep_ref)
			else
				Result := l_buffer.copied_general (Current)
			end
		end

	raw_string_8 (keep_ref: BOOLEAN): STRING_8
		-- string with unadjusted whitespace
		local
			l_buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			if encoded_as_utf (8) then
				Result := Precursor (keep_ref)
			else
				Result := l_buffer.copied (Current)
			end
			if keep_ref then
				Result := Result.twin
			end
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
			Result := adjusted (False)
			Result.expand
-- 		There are many cases where we may want to have a non-absolute path			
--			if not Result.is_absolute and then not document_dir.is_empty then
--				Result := document_dir.joined_dir_path (Result)
--			end
		end

	to_expanded_file_path: FILE_PATH
		do
			Result := adjusted (False)
			Result.expand
			if not Result.is_absolute and then not document_dir.is_empty then
				Result := document_dir.joined_file_path (Result)
			end
		end

	to_pointer: POINTER
		do
		end

	to_trim_lines: EL_ZSTRING_LIST
		-- left and right adjusted list of line strings
		do
			create Result.make_with_lines (adjusted (False))
			across Result as line loop
				line.item.adjust
			end
		end

feature -- Element change

	set_from_view (view: EL_STRING_VIEW)
		do
			wipe_out
			if attached {EL_STRING_8_VIEW} view as string_8 then
				string_8.append_to_string_8 (Current)
			else
				view.append_to (Current)
			end
		end

	set_type (a_type: INTEGER)
		do
			type := a_type
		end

feature {EL_DOCUMENT_CLIENT} -- Internal attributes

	raw_name: EL_UTF_8_STRING

end
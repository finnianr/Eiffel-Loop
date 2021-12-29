note
	description: "Windows implementation of [$source EL_OS_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-29 17:21:22 GMT (Wednesday 29th December 2021)"
	revision: "11"

deferred class
	EL_OS_COMMAND_IMP

inherit
	EL_OS_COMMAND_I
		undefine
			getter_function_table, make_default, Transient_fields
		end

	EL_OS_IMPLEMENTATION

	EL_MODULE_ENCODINGS

	EL_FILE_OPEN_ROUTINES

feature -- Basic operations

	new_output_lines (file_path: EL_FILE_PATH): EL_ZSTRING_LIST
		local
			line: ZSTRING; console_encoding, unicode_encoding: ENCODING; line_one, content, raw_line: STRING
			s8: EL_STRING_8_ROUTINES; line_split: EL_ITERABLE_SPLIT [STRING, ANY]
			utf_16_le: EL_UTF_16_LE_CONVERTER; is_utf_16_le: BOOLEAN
		do
			if file_path.exists and then attached open_raw (file_path, Read) as file then
				file.read_stream (file.count)
				content := file.last_string
				line_one := s8.substring_to (content, '%N', default_pointer)
				file.close
			else
				create line_one.make_empty
				content := line_one
			end
			if utf_16_le.is_valid_string_8 (line_one) then
				is_utf_16_le := True
				if content.ends_with (Utf_16_cr_new_line) then
					content.remove_tail (Utf_16_cr_new_line.count)
				end
				create {EL_SPLIT_ON_STRING [STRING]} line_split.make (content, Utf_16_cr_new_line)
			else
				create {EL_SPLIT_ON_CHARACTER [STRING]} line_split.make (content, '%N')
				-- Convert from console encoding
			end
			console_encoding := Encodings.Console; unicode_encoding := Encodings.Unicode
			create Result.make (content.occurrences ('%N') + 1)
			across line_split as split loop
				raw_line := split.item
				if is_utf_16_le then
					create line.make (utf_16_le.unicode_count (raw_line))
					line.append_utf_16_le (raw_line)
					Result.extend (line)
				else
					console_encoding.convert_to (unicode_encoding, raw_line)
					if console_encoding.last_conversion_successful then
						Result.extend (console_encoding.last_converted_string_32)
					end
				end
			end
		end

feature -- Constants

	Command_prefix: STRING_32
		-- Force output of command to be UTF-16
		once
			Result := "cmd /U /C"
		end

	Error_redirection_suffix: STRING = ""

	Utf_16_cr_new_line: STRING = "%R%U%N%U"
		-- little endian CR + NL

end
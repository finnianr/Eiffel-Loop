note
	description: "Windows implementation of [$source EL_OS_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

deferred class
	EL_OS_COMMAND_IMP

inherit
	EL_OS_COMMAND_I

	EL_OS_IMPLEMENTATION

	EL_MODULE_UTF

	SYSTEM_ENCODINGS

	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		end

feature -- Basic operations

	new_output_lines (file_path: EL_FILE_PATH): EL_ZSTRING_LIST
		local
			file: RAW_FILE; raw_text: NATIVE_STRING; list: LIST [READABLE_STRING_GENERAL]
			line: ZSTRING; l_encoding: ENCODING
		do
			create file.make_open_read (file_path)
			file.read_stream (file.count)
			file.close
			if UTF.is_valid_utf_16le_string_8 (file.last_string) then
				create raw_text.make_from_raw_string (file.last_string)
				list := raw_text.string.split ('%N')
			else
				-- Convert from console encoding
				l_encoding := Console_encoding
				create {EL_ZSTRING_LIST} list.make (file.last_string.occurrences ('%N') + 1)
				across file.last_string.split ('%N') as l_line loop
					l_encoding.convert_to (utf32, l_line.item)
					if l_encoding.last_conversion_successful then
						list.extend (as_zstring (l_encoding.last_converted_string_32))
					end
				end
			end
			create Result.make (list.count)
			from list.start until list.after loop
				create line.make_from_general (list.item)
				line.prune_all_trailing ('%R')
				if not line.is_empty then
					Result.extend (line)
				end
				list.forth
			end
		end

feature -- Constants

	Command_prefix: STRING_32
			-- Force output of command to be UTF-16
		once
			Result := "cmd /U /C "
		end

	Error_redirection_suffix: STRING = ""

end
note
	description: "Windows implementation of `EL_OS_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-24 9:59:54 GMT (Friday 24th June 2016)"
	revision: "1"

deferred class
	EL_OS_COMMAND_IMP

inherit
	EL_OS_COMMAND_I

	EL_OS_IMPLEMENTATION

feature -- Basic operations

	new_output_lines (file_path: EL_FILE_PATH): EL_ZSTRING_LIST
		local
			file: RAW_FILE; raw_text: NATIVE_STRING; list: LIST [STRING_32]
		do
			create file.make_open_read (file_path)
			file.read_stream (file.count)
			create raw_text.make_from_raw_string (file.last_string)
			file.close
			list := raw_text.string.split ('%N')
			create Result.make (list.count)
			from list.start until list.after loop
				list.item.prune_all_trailing ('%R')
				if not list.item.is_empty then
					Result.extend (list.item)
				end
				list.forth
			end
		end

	escaped_path (a_path: EL_PATH): ZSTRING
		do
			Result := a_path.to_string
			if Result.has (' ') then
				Result.quote (2)
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
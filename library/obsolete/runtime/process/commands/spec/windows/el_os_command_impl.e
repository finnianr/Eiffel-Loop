note
	description: "Summary description for {EL_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-13 17:13:54 GMT (Monday 13th June 2016)"
	revision: "5"

deferred class
	EL_OS_COMMAND_IMPL

inherit
	EL_OS_COMMAND_INTERFACE
		redefine
			captured_system_command
		end

	EL_OS_IMPLEMENTATION

feature -- Access

	captured_system_command (command: ZSTRING): ZSTRING
		do
			Result := "cmd /U /C "
			Result.append (Precursor (command))
		end

feature -- Basic operations

	new_output_lines: EL_ZSTRING_LIST
		local
			file: RAW_FILE; raw_text: NATIVE_STRING; list: LIST [STRING_32]
		do
			create file.make_open_read (output_file_path)
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

	Error_redirection_suffix: STRING = ""

end

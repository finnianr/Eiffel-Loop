note
	description: "Summary description for {EL_JPEG_FILE_INFO_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 8:06:32 GMT (Thursday 29th June 2017)"
	revision: "1"

deferred class
	EL_JPEG_FILE_INFO_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as file_path,
			set_path as set_file_path
		export
			{NONE} all
		undefine
			do_command, new_command_string
		redefine
			make, make_default, file_path
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			make_default
		end

feature {NONE} -- Initialization

	make (a_file_path: like file_path)
			--
		do
			Precursor (a_file_path)
			execute
		end

	make_default
		do
			date_time := Default_date_time
			Precursor {EL_SINGLE_PATH_OPERAND_COMMAND_I}
		end

feature -- Access

	date_time: DATE_TIME

	file_path: EL_FILE_PATH

feature -- Status query

	had_date_time: BOOLEAN
		do
			Result := date_time /= Default_date_time
		end

feature {NONE} -- Implementation

	do_with_lines (lines: like adjusted_lines)
			--
		do
			if not has_error and then not lines.is_empty then
				lines.start
				if lines.item.occurrences (':') = 4 then
					create date_time.make_from_string (lines.item, Format_string)
				end
			end
		end

feature {NONE} -- Constants

	Default_date_time: DATE_TIME
		once
			create Result.make_from_epoch (0)
		end

	Format_string: STRING = "yyyy:[0]mm:[0]dd [0]hh:[0]mi:[0]ss"

end

note
	description: "Summary description for {EL_JPEG_FILE_INFO_COMMAND_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-01 13:05:49 GMT (Saturday 1st July 2017)"
	revision: "2"

deferred class
	EL_JPEG_FILE_INFO_COMMAND_I

inherit
	EL_FILE_PATH_OPERAND_COMMAND_I
		export
			{NONE} all
		undefine
			do_command, new_command_string
		redefine
			set_file_path, make_default, set_has_error
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			make_default, set_has_error
		end

feature {NONE} -- Initialization

	make_default
		do
			date_time := Default_date_time
			Precursor {EL_FILE_PATH_OPERAND_COMMAND_I}
		end

feature -- Access

	date_time: DATE_TIME

feature -- Status query

	has_date_time: BOOLEAN
		do
			Result := date_time /= Default_date_time
		end

feature -- Element change

	set_file_path (a_file_path: like file_path)
			--
		do
			Precursor (a_file_path)
			date_time := Default_date_time
			execute
		end

feature {NONE} -- Implementation

	do_with_lines (lines: like adjusted_lines)
			--
		local
			tail: ZSTRING
		do
			if not lines.is_empty then
				lines.start
				tail := lines.item.tail (19)
				if tail.occurrences (':') = 4 then
					create date_time.make_from_string (tail, Format_string)
				end
			end
		end

	set_has_error (return_code: INTEGER)
		-- exiv2 has a non-standard way of indicating an error
		do
			has_error := File_system.file_byte_count (temporary_error_file_path) > 0
		end

feature {NONE} -- Constants

	Default_date_time: DATE_TIME
		once
			create Result.make_from_epoch (0)
		end

	Format_string: STRING = "yyyy:[0]mm:[0]dd [0]hh:[0]mi:[0]ss"

end

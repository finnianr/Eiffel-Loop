note
	description: "Jpeg file info command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

deferred class
	EL_JPEG_FILE_INFO_COMMAND_I

inherit
	EL_FILE_PATH_OPERAND_COMMAND_I
		export
			{NONE} all
		undefine
			do_command, new_command_parts
		redefine
			set_file_path, make_default, set_has_error
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			getter_function_table, make_default, set_has_error, Transient_fields
		end

	EL_MODULE_FILE

feature {NONE} -- Initialization

	make_default
		do
			date_time := Default_date_time
			Precursor {EL_FILE_PATH_OPERAND_COMMAND_I}
		end

feature -- Access

	date_time: EL_DATE_TIME

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

	do_with_lines (lines: like new_output_lines)
			--
		local
			tail: ZSTRING
		do
			if not lines.is_empty then
				lines.start
				tail := lines.item.tail (19)
				if tail.occurrences (':') = 4 then
					create date_time.make_with_format (tail, Format_string)
				end
			end
		end

	set_has_error (return_code: INTEGER)
		-- exiv2 has a non-standard way of indicating an error
		do
			has_error := File.byte_count (temporary_error_file_path) > 0
		end

feature {NONE} -- Constants

	Default_date_time: EL_DATE_TIME
		once
			create Result.make_from_epoch (0)
		end

	Format_string: STRING = "yyyy:[0]mm:[0]dd [0]hh:[0]mi:[0]ss"

end
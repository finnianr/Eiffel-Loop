note
	description: "Wrapper for Unix **grep** command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-17 16:05:51 GMT (Thursday 17th February 2022)"
	revision: "2"

class
	GREP_COMMAND

inherit
	EL_PARSED_CAPTURED_OS_COMMAND [TUPLE [options, file_path: STRING]]
		redefine
			make
		end

create
	execute, make

feature {NONE} -- Initialization

	make
		do
			Precursor
			set_output_encoding (Latin_1)
		end

feature -- Access

	source_path: FILE_PATH

feature -- Basic operations

	collect (results_table: EL_HASH_TABLE [EL_ZSTRING_LIST, FILE_PATH])
		do
			if lines.count > 0 then
				lines.left_adjust
				results_table.extend (lines.twin, source_path)
				lines.wipe_out
			end
		end

feature -- Element change

	set_source_path (a_path: FILE_PATH)
		do
			put_path (var.file_path, a_path)
			source_path := a_path
		end

	set_options (options: ZSTRING)
		do
			put_string (var.options, options)
		end

feature {NONE} -- Constants

	Template: STRING = "grep $OPTIONS $FILE_PATH"

end
note
	description: "Use Unix **grep** command to recursively search directories of Eiffel source code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EIFFEL_GREP_COMMAND

inherit
	EL_PARSED_CAPTURED_OS_COMMAND [TUPLE [options, source_dir: STRING]]
		redefine
			make, set_has_error
		end

create
	execute, make

feature {NONE} -- Initialization

	make
		do
			Precursor
--			set_output_encoding (Latin_1)
		end

feature -- Access

	source_dir: DIR_PATH

feature -- Element change

	set_options (options: ZSTRING)
		do
			put_string (var.options, options)
		end

	set_source_dir (a_path: DIR_PATH)
		do
			put_path (var.source_dir, a_path)
			source_dir := a_path
		end

feature {NONE} -- Implementation

	set_has_error (return_code: INTEGER)
		do
			inspect return_code
				when 0, 256 then
					has_error := False
			else
				has_error := True
			end
		end

feature {NONE} -- Constants

	Template: STRING = "[
		grep --recursive --include "*.e" $OPTIONS $SOURCE_DIR
	]"

end
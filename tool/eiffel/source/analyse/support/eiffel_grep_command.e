note
	description: "Use Unix **grep** command to recursively search directories of Eiffel source code"
	notes: "[
		grep distributed as part of Eiffel Studio for Windows lacks `--include' option
		
			D:\Program Files\Eiffel_16.05\gcc\win64\msys\1.0\bin
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-21 12:35:24 GMT (Wednesday 21st June 2023)"
	revision: "8"

class
	EIFFEL_GREP_COMMAND

inherit
	EL_PARSED_CAPTURED_OS_COMMAND [TUPLE [options: STRING]]
		redefine
			make, set_has_error
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			set_output_encoding (Mixed_utf_8_latin_1)
		end

feature -- Element change

	set_options (options: READABLE_STRING_GENERAL)
		do
			put_string (var.options, options)
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
		grep --recursive --line-number --include "*.e" $OPTIONS
	]"

end
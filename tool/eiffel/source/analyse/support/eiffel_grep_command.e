note
	description: "Use Unix **grep** command to recursively search directories of Eiffel source code"
	notes: "[
		grep distributed as part of Eiffel Studio for Windows lacks `--include' option
		
			D:\Program Files\Eiffel_16.05\gcc\win64\msys\1.0\bin
			
		**Fixed Strings**
			
		When using --fixed-strings option (-F), make sure any '$' character is escaped.
		
			grep --recursive --line-number --include "*.e" -F "{\${"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 9:24:32 GMT (Tuesday 9th July 2024)"
	revision: "10"

class
	EIFFEL_GREP_COMMAND

inherit
	EL_PARSED_CAPTURED_OS_COMMAND [TUPLE [options: STRING]]
		redefine
			default_template, make, set_has_error
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

	Default_template: STRING = "[
		grep --recursive --line-number --include "*.e" $OPTIONS
	]"

end
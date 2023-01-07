note
	description: "Use Unix **grep** command to recursively search directories of Eiffel source code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-07 17:05:19 GMT (Saturday 7th January 2023)"
	revision: "6"

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

	set_options (options: ZSTRING)
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
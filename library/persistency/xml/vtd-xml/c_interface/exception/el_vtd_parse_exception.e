note
	description: "${EL_VTD_EXCEPTION} for XML document parsing errors"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_VTD_PARSE_EXCEPTION

inherit
	EL_VTD_EXCEPTION
		rename
			line_number as eiffel_line_number
		redefine
			put_error
		end

create
	make_full

feature -- Access

	line_number: INTEGER

	line_offset: INTEGER

feature -- Element change

	set_position (a_line_number,  a_line_offset: INTEGER)
		do
			line_number := a_line_number; line_offset := a_line_offset
		end

feature -- Basic operations

	put_error (log: EL_LOGGABLE)
		do
			Precursor (log)
			log.put_substitution (Line_template, [line_number, line_offset])
			log.put_new_line
		end

feature {NONE} -- Constants

	Line_template: ZSTRING
		once
			Result := "Line number: %S, Offset: %S"
		end
end
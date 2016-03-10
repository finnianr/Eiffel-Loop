note
	description: "Summary description for {EL_STRING_MEDIUM_LINE_SOURCE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-03 11:23:22 GMT (Wednesday 3rd July 2013)"
	revision: "2"

class
	EL_TEXT_LINE_SOURCE

inherit
	EL_LINE_SOURCE [EL_TEXT_IO_MEDIUM]
		redefine
			default_create
		end

create
	default_create, make, make_from_string

feature {NONE} -- Initialization

	default_create
			--
		do
			Precursor
			create source.make (0)
		end

	make_from_string (a_string: STRING)
		do
			default_create
			make (create {EL_TEXT_IO_MEDIUM}.make_open_read_from_string (a_string))
		end

feature {EL_LINE_SOURCE_ITERATION_CURSOR} -- Implementation

	source_copy: EL_TEXT_IO_MEDIUM
		do
			create Result.make_open_read_from_string (source.text)
		end

end

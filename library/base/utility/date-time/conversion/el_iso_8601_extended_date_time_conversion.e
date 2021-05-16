note
	description: "El ISO 8601 EXTENDED DATE TIME CONVERSION"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-16 10:27:03 GMT (Sunday 16th May 2021)"
	revision: "1"

class
	EL_ISO_8601_EXTENDED_DATE_TIME_CONVERSION

inherit
	EL_ISO_8601_DATE_TIME_CONVERSION
		redefine
			make, Index_of_T, Input_string_count, put_T, put_separator
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_format (Date_time.ISO_8601.date_extended + " " + Date_time.ISO_8601.time_extended)
		end

feature {NONE} -- Implementation

	put_T (out_string: STRING)
		do
			out_string [Index_of_T] := 'T'
		end

	put_separator (out_string: STRING)
		do
			out_string.append_character (' ')
		end

feature {NONE} -- Constants

	Index_of_T: INTEGER
		once
			Result := 11
		end

	Input_string_count: INTEGER
		once
			Result := 20
		end

end
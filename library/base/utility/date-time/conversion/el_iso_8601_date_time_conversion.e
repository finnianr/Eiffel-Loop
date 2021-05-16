note
	description: "[
		Implementation of [$source EL_DATE_TIME_CONVERSION] for the
		[https://en.wikipedia.org/wiki/ISO_8601 ISO-8601 date-time format]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-16 10:27:04 GMT (Sunday 16th May 2021)"
	revision: "3"

class
	EL_ISO_8601_DATE_TIME_CONVERSION

inherit
	EL_DATE_TIME_CONVERSION
		rename
			make as make_format
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_format (Date_time.ISO_8601.date + Date_time.ISO_8601.time)
		end

feature -- Access

	formatted_out (dt: EL_DATE_TIME): STRING
		do
			if attached dt.Code_string_table.item (format) as code then
				Result := code.new_string (dt)
				put_T (Result)
				Result.append_character ('Z')
			else
				create Result.make_empty
			end
		end

	modified_string (s: STRING): STRING
		do
			Result := Buffer_8.copied_substring (s, 1, Index_of_T - 1)
			put_separator (Result)
			Result.append_substring (s, Index_of_T + 1, Input_string_count - 1)
		end

feature -- Status query

	is_valid_string (s: STRING): BOOLEAN
		do
			if s.count = Input_string_count then
				Result := s [Index_of_T] = 'T' and s [Input_string_count] = 'Z'
			end
		end

feature {NONE} -- Implementation

	put_T (out_string: STRING)
		do
			out_string.insert_character ('T', Index_of_T)
		end

	put_separator (out_string: STRING)
		do
		end

feature {NONE} -- Constants

	Index_of_T: INTEGER
		once
			Result := 9
		end

	Input_string_count: INTEGER
		once
			Result := 16
		end

end
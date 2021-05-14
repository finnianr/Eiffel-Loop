note
	description: "[
		Implementation of [$source EL_DATE_TIME_CONVERSION] for the
		[https://en.wikipedia.org/wiki/ISO_8601 ISO-8601 date-time format]
	]" 
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	make (a_format: STRING; a_index_of_T, a_input_string_count: INTEGER)
		do
			make_format (a_format)
			index_of_t := a_index_of_t; input_string_count := a_input_string_count
		end

	feature -- Access

	formatted_out (dt: EL_DATE_TIME): STRING
		do
			if attached dt.Code_string_table.item (format) as code then
				Result := code.new_string (dt)
				Result [index_of_T] := 'T'
				Result.append_character ('Z')
			else
				create Result.make_empty
			end
		end

	modified_string (s: STRING): STRING
		do
			Result := Buffer_8.copied_substring (s, 1, index_of_T - 1)
			if input_string_count = 20 then
				Result.append_character (' ')
			end
			Result.append_substring (s, index_of_T + 1, input_string_count - 1)
		end

	feature -- Status query

	is_valid_string (s: STRING): BOOLEAN
		do
			if s.count = input_string_count then
				Result := s [index_of_T] = 'T' and s [input_string_count] = 'Z'
			end
		end

	feature {NONE} -- Internal attributes

	index_of_T: INTEGER

	input_string_count: INTEGER

	end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-14 11:01:12 GMT (Friday 14th May 2021)"
	revision: "1"

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

	make (a_format: STRING; a_index_of_T, a_input_string_count: INTEGER)
		do
			make_format (a_format)
			index_of_t := a_index_of_t; input_string_count := a_input_string_count
		end

feature -- Access

	formatted_out (dt: EL_DATE_TIME): STRING
		do
			if attached dt.Code_string_table.item (format) as code then
				Result := code.new_string (dt)
				Result [index_of_T] := 'T'
				Result.append_character ('Z')
			else
				create Result.make_empty
			end
		end

	modified_string (s: STRING): STRING
		do
			Result := Buffer_8.copied_substring (s, 1, index_of_T - 1)
			if input_string_count = 20 then
				Result.append_character (' ')
			end
			Result.append_substring (s, index_of_T + 1, input_string_count - 1)
		end

feature -- Status query

	is_valid_string (s: STRING): BOOLEAN
		do
			if s.count = input_string_count then
				Result := s [index_of_T] = 'T' and s [input_string_count] = 'Z'
			end
		end

feature {NONE} -- Internal attributes

	index_of_T: INTEGER

	input_string_count: INTEGER

end
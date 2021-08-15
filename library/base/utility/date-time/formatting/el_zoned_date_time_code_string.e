note
	description: "[$source EL_DATE_TIME_CODE_STRING] class with support for time zone designators"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-15 14:21:42 GMT (Sunday 15th August 2021)"
	revision: "1"

class
	EL_ZONED_DATE_TIME_CODE_STRING

inherit
	EL_DATE_TIME_CODE_STRING
		rename
			make as make_code_string
		redefine
			adjusted_format, append_to, new_parser
		end

create
	make

feature {NONE} -- Initialization

	make (format: STRING; a_zone_designator_count: INTEGER)
		do
			zone_designator_count := a_zone_designator_count
			make_code_string (format)
		end

feature -- Access

	new_parser: EL_ZONED_DATE_TIME_PARSER
		do
			create Result.make (Current)
		end

	zone_designator_count: INTEGER

feature -- Basic operations

	append_to (str: STRING; dt: DATE_TIME)
		do
			Precursor (str, dt)
			str.append (Zone_designator [zone_designator_count])
		end

feature {NONE} -- Implementation

	adjusted_format (a_str: STRING): STRING
		-- `format' with time zone designators removed
		local
			s: EL_STRING_8_ROUTINES; end_index: INTEGER
		do
			end_index := s.leading_string_count (a_str, zone_designator_count)
			if attached String_8_pool.new_scope as pool and then attached pool.reuse_item as str then
				str.append_substring (a_str, 1, end_index)
				Result := str
				pool.recycle_end (str)
			end
		end

feature {NONE} -- Constants

	Zone_designator: SPECIAL [STRING]
		once
			create Result.make_filled (Empty_string_8, 3)
			Result [1] := " UTC"
			Result [2] := " GMT+0000 (GMT)"
		end

end
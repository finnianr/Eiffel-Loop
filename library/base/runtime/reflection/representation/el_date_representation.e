note
	description: "A reflected [$source INTEGER_32] representing a [$source DATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-04 8:48:40 GMT (Friday 4th June 2021)"
	revision: "4"

class
	EL_DATE_REPRESENTATION

inherit
	EL_STRING_REPRESENTATION [INTEGER, DATE]
		rename
			item as date
		end

create
	make

feature {NONE} -- Initialization

	make (a_format: STRING)
		do
			format := a_format
			create date.make_now
		end

feature -- Access

	to_string (a_value: like to_value): STRING
		do
			if date.ordered_compact_date_valid (a_value) then
				date.make_by_ordered_compact_date (a_value)
				Result := date.formatted_out (format)
			else
				create Result.make_empty
			end
		end

	format: STRING

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- " + date.generator + ": " + format)
		end

	to_value (str: READABLE_STRING_GENERAL): INTEGER
		do
			date.make_from_string (Buffer_8.copied_general (str), format)
			Result := date.ordered_compact_date
		end

end
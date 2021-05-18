note
	description: "A reflected [$source INTEGER_32] representing a [$source DATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-18 13:42:19 GMT (Tuesday 18th May 2021)"
	revision: "1"

class
	EL_DATE_REPRESENTATION

inherit
	EL_DATA_REPRESENTATION [INTEGER, DATE]
		rename
			item as date
		redefine
			default_create
		end

feature -- Access

	to_string (a_value: like to_value): STRING
		do
			date.make_by_ordered_compact_date (a_value)
			Result := date.out
		end

feature {NONE} -- Initialization

	default_create
		do
			create date.make_now
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- " + date.generator + ": " + date.date_default_format_string)
		end

	to_value (str: READABLE_STRING_GENERAL): INTEGER
		do
			date.make_from_string_default (Buffer_8.copied_general (str))
			Result := date.ordered_compact_date
		end

end
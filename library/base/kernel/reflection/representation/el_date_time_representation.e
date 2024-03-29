note
	description: "A reflected ${INTEGER_32} representing a ${EL_DATE_TIME}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "7"

class
	EL_DATE_TIME_REPRESENTATION

inherit
	EL_STRING_FIELD_REPRESENTATION [INTEGER, EL_DATE_TIME]
		rename
			item as date_time
		end

create
	make

feature {NONE} -- Initialization

	make (a_format: STRING)
		do
			format := a_format
			create date_time.make_from_epoch (0)
		end

feature -- Access

	to_string (a_value: like to_value): STRING
		do
			date_time.make_from_epoch (a_value)
			Result := date_time.formatted_out (format)
		end

	format: STRING

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- " + date_time.generator + ": " + format)
		end

	to_value (string: READABLE_STRING_GENERAL): INTEGER
		local
			t: EL_TIME_ROUTINES
		do
			if attached Buffer_8.copied_general (string) as str_8 then
				date_time.make_with_format (str_8, format)
				Result := t.unix_date_time (date_time)
			end
		end
end
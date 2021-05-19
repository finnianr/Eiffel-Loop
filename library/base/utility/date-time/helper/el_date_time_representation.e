note
	description: "A reflected [$source INTEGER_32] representing a [$source EL_DATE_TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-19 8:54:04 GMT (Wednesday 19th May 2021)"
	revision: "2"

class
	EL_DATE_TIME_REPRESENTATION

inherit
	EL_STRING_REPRESENTATION [INTEGER, EL_DATE_TIME]
		rename
			item as date_time
		end

	EL_MODULE_TIME

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
		do
			if attached Buffer_8.copied_general (string) as str_8 then
				date_time.make_with_format (str_8, format)
				Result := Time.unix_date_time (date_time)
			end
		end
end
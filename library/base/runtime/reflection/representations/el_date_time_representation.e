note
	description: "A reflected [$source INTEGER_32] representing a [$source DATE_TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-18 13:42:55 GMT (Tuesday 18th May 2021)"
	revision: "1"

class
	EL_DATE_TIME_REPRESENTATION

inherit
	EL_DATA_REPRESENTATION [INTEGER, DATE_TIME]
		rename
			item as date_time
		redefine
			default_create
		end

	EL_MODULE_TIME

feature {NONE} -- Initialization

	default_create
		do
			create date_time.make_from_epoch (0)
		end

feature -- Access

	to_string (a_value: like to_value): STRING
		do
			date_time.make_from_epoch (a_value)
			Result := date_time.out
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- " + date_time.generator + ": " + date_time.date_default_format_string)
		end

	to_value (string: READABLE_STRING_GENERAL): INTEGER
		do
			if attached Buffer_8.copied_general (string) as str_8 then
				date_time.make_from_string_default (str_8)
				Result := Time.unix_date_time (date_time)
			end
		end
end
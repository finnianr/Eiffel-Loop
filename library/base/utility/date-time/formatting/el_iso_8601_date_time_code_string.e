note
	description: "[$source EL_DATE_TIME_CODE_STRING] for ISO-8601 date-time formats"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_ISO_8601_DATE_TIME_CODE_STRING

inherit
	EL_DATE_TIME_CODE_STRING
		rename
			make as make_code_string
		redefine
			append_to, correspond, is_date_time, new_parser
		end

create
	make

feature {NONE} -- Initialization

	make (format: STRING; a_converter: EL_DATE_TIME_CONVERSION)
		do
			converter := a_converter
			make_code_string (a_converter.format)
		end

feature -- Access

	new_parser: EL_ISO_8601_DATE_TIME_PARSER
		do
			create Result.make (Current)
		end

feature -- Status query

	correspond (str_upper: STRING): BOOLEAN
		do
			if converter.is_valid_string (str_upper) then
				Result := Precursor (converter.modified_string (str_upper))
			end
		end

	is_date_time (str_upper: STRING): BOOLEAN
		do
			Result := Precursor (converter.modified_string (str_upper))
		end

feature -- Basic operations

	append_to (str: STRING; dt: EL_DATE_TIME)
		do
			converter.append_to (str, dt)
		end

feature {EL_DATE_TIME, EL_DATE_TIME_PARSER} -- Internal attributes

	converter: EL_DATE_TIME_CONVERSION

end
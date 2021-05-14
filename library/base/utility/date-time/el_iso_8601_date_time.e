note
	description: "Date-time object makeable from canonical ISO-8601 formatted string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-14 6:38:11 GMT (Friday 14th May 2021)"
	revision: "12"

class
	EL_ISO_8601_DATE_TIME

inherit
	EL_DATE_TIME
		redefine
			Default_format_string
		end

create
	make, make_now, make_from_other

convert
	make_from_other ({DATE_TIME})

feature -- Constant

	Default_format_string: STRING
			-- Default output format string
		once
			Result := Date_time.Format_iso_8601
		end

end
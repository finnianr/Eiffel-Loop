note
	description: "[
		Date-time object makeable from short-form ISO-8601 formatted string
	]"
	notes: "[
		Due to [https://groups.google.com/forum/#!topic/eiffel-users/XdLwHGX_X7c formatting problems]
		with `DATE_TIME' we cannot have a space in the `Default_format_string' like in the parent class.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-14 9:38:15 GMT (Saturday 14th August 2021)"
	revision: "6"

class
	EL_SHORT_ISO_8601_DATE_TIME

inherit
	EL_DATE_TIME
		rename
			make as make_from_parts,
			make_from_string as make
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
			Result := Date_time.ISO_8601.format
		end

end
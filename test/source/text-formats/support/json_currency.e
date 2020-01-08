note
	description: "Json currency"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 13:06:17 GMT (Wednesday 8th January 2020)"
	revision: "5"

class
	JSON_CURRENCY

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		end

	EL_SETTABLE_FROM_JSON_STRING

create
	make_from_json, make

feature {NONE} -- Initialization

	make (a_name: like name; a_symbol: like symbol; a_code: like code)
		do
			make_default
			name := a_name; symbol := a_symbol; code := a_code
		end

feature -- Access

	code: STRING

	name: ZSTRING

	symbol: ZSTRING

end

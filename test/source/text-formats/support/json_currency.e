note
	description: "JSON currency"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	JSON_CURRENCY

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		end

	JSON_SETTABLE_FROM_STRING

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
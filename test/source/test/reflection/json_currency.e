note
	description: "Summary description for {JSON_CURRENCY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 16:25:28 GMT (Thursday 28th December 2017)"
	revision: "2"

class
	JSON_CURRENCY

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field
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

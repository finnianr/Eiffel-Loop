note
	description: "Personal data convertable to/from JSON"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-21 8:27:40 GMT (Tuesday 21st June 2022)"
	revision: "4"

class
	PERSON

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		end

	EL_JSON_SETTABLE_FROM_STRING

create
	make_default, make_from_json

feature -- Access

	gender: CHARACTER_32
		-- symbol ♂ male OR ♀ female

	name: ZSTRING

	city: STRING_32

	age: INTEGER

end
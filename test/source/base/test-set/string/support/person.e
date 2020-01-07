note
	description: "Personal data convertable to/from JSON"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-19 13:22:12 GMT (Wednesday 19th September 2018)"
	revision: "1"

class
	PERSON

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		end

	EL_SETTABLE_FROM_JSON_STRING

create
	make_default, make_from_json

feature -- Access

	gender: CHARACTER_32
		-- symbol ♂ male OR ♀ female

	name: ZSTRING

	city: STRING_32

	age: INTEGER

end

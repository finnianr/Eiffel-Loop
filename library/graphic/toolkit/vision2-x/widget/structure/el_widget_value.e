note
	description: "Initialization value for widgets"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "4"

class
	EL_WIDGET_VALUE [G]

create
	make

feature {NONE} -- Initialization

	make (initial_value, a_value: G; a_string: like as_string)
		do
			value := a_value; as_string := a_string
			is_current := a_value ~ initial_value
		end

feature -- Access

	as_string: ZSTRING

	as_string_32: STRING_32
		do
			Result := as_string.to_string_32
		end

	value: G

feature -- Status query

	is_current: BOOLEAN

end
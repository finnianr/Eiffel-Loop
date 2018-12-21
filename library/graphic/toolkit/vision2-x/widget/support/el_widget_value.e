note
	description: "Initialization value for widgets conforming to [$source EL_INPUT_WIDGET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-20 12:20:29 GMT (Sunday 20th May 2018)"
	revision: "1"

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

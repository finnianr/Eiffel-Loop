note
	description: "Parsed xpath step"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-02 9:41:21 GMT (Wednesday 2nd November 2022)"
	revision: "1"

class
	EL_PARSED_XPATH_STEP

create
	make

feature {NONE} -- Initialization

	make (a_step: like step)
			--
		do
			step := a_step
			create element_name.make_empty
			create selecting_attribute_name.make_empty
			create selecting_attribute_value.make_empty
		end

feature -- Access

	element_name: STRING

	selecting_attribute_name: STRING

	selecting_attribute_value: STRING

	step: STRING

feature -- Status query

	has_selection_by_attribute: BOOLEAN
		do
			Result := not selecting_attribute_name.is_empty
		end

end
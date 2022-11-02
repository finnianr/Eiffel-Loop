note
	description: "Parsed xpath step"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-02 9:20:46 GMT (Wednesday 2nd November 2022)"
	revision: "8"

class
	EL_PARSED_XPATH_STEP

inherit
	ANY

	EL_STRING_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_step: like step)
			--
		do
			element_name := Empty_string_8
			selecting_attribute_name := Empty_string_8
			selecting_attribute_value := Empty_string_8
			step := a_step
		end

feature -- Element change

	set_element_name (an_element_name: STRING)
		do
			element_name := an_element_name
		end

	set_selecting_attribute_name (attribute_name: STRING)
			--
		do
			selecting_attribute_name := attribute_name
		end

	set_selecting_attribute_value (attribute_value: STRING)
			--
		do
			selecting_attribute_value := attribute_value
		end

feature -- Access

	element_name: STRING

	selecting_attribute_name: STRING

	selecting_attribute_value: STRING

	step: STRING

feature -- Status query

	has_selection_by_attribute: BOOLEAN
		do
			Result := selecting_attribute_name /= Empty_string_8
		end

end
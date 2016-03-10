note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-14 14:55:17 GMT (Monday 14th December 2015)"
	revision: "4"

class
	EL_PARSED_XPATH_STEP

inherit
	EL_STRING_CONSTANTS

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

	set_element_name (an_element_name: like element_name)
			-- Set `element_name' to `an_element_name'.
		do
			element_name := an_element_name
		ensure
			element_name_assigned: element_name = an_element_name
		end

	set_selecting_attribute_name (attribute_name: like selecting_attribute_name)
			--
		do
			selecting_attribute_name := attribute_name
		end

	set_selecting_attribute_value (attribute_value: like selecting_attribute_value)
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

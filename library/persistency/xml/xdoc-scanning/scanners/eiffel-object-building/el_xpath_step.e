note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_XPATH_STEP

create
	make
	
feature {NONE} -- Initialization

	make (a_step: STRING)
			-- 
		do
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

	set_selecting_attribute_name (attribute_name: STRING)
			-- 
		do
			selecting_attribute_name := attribute_name
			has_selection_by_attribute_value := true
		end
		
	set_selecting_attribute_value (attribute_value: STRING)
			-- 
		do
			selecting_attribute_value := attribute_value
		end

feature -- Access

	element_name: STRING

	step: STRING

	selecting_attribute_name: STRING
	
	selecting_attribute_value: STRING
	
feature -- Status query

	has_selection_by_attribute_value: BOOLEAN 
		
end

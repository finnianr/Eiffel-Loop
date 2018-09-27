note
	description: "XML tag containing a single text node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	EL_XML_VALUE_TAG_PAIR

inherit
	EL_XML_TAG_LIST
		redefine
			new_line_after_open_tag
		end
		
create
	make, make_from_other

feature -- Element change
	
	set_integer_value (value: INTEGER)
			--
		do
			set_string_value (value.out)
		end
		
	set_real_value (value: REAL)
			--
		do
			set_string_value (value.out)
		end

	set_boolean_value (value: BOOLEAN)
			--
		do
			set_string_value (value.out)
		end
		
	set_string_value (value: STRING)
			--
		do
			finish
			if count = 2 then
				put_left (value)
			else
				back
				replace (value)
			end
		end

feature {NONE} -- Implementation

	new_line_after_open_tag: BOOLEAN = false

end

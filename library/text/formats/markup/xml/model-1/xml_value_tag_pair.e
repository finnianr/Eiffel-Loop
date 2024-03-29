note
	description: "XML tag containing a single text node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	XML_VALUE_TAG_PAIR

inherit
	XML_TAG_LIST
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
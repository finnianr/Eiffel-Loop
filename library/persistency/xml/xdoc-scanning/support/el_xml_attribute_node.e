note
	description: "Summary description for {EL_XML_ATTRIBUTE_NODE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_XML_ATTRIBUTE_NODE

inherit
	EL_XML_NODE
		redefine
			default_create, xpath_name
		end
create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			Precursor
			create actual_xpath_name.make (12)
			actual_xpath_name.append_character ('@')
			type := Node_type_attribute
		end

feature -- Access

	xpath_name: STRING_32
			--
		do
			if type = Node_type_attribute then
				actual_xpath_name.remove_tail (actual_xpath_name.count - 1)
				actual_xpath_name.append (name)
				Result := actual_xpath_name
			else
				Result := Precursor
			end
		end

feature {NONE} -- Implementation

	actual_xpath_name: like xpath_name

	Node_type_attribute: INTEGER = 5

end

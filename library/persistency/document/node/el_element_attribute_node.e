note
	description: "Xml attribute node"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-20 14:06:54 GMT (Sunday 20th December 2020)"
	revision: "8"

class
	EL_ELEMENT_ATTRIBUTE_NODE

inherit
	EL_DOCUMENT_NODE
		redefine
			make, xpath_name
		end

create
	make

feature {NONE} -- Initialization

	make
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
note
	description: "Element containing either an element list or some text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-09 13:02:08 GMT (Thursday 9th April 2020)"
	revision: "4"

deferred class
	EL_XML_CONTENT_ELEMENT

inherit
	EL_XML_EMPTY_ELEMENT
		undefine
			write
		redefine
			make, is_equal, name_end_index, Open_template
		end

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL)
		do
			Precursor (a_name)
			closed := close_template #$ [a_name]
		end

feature -- Access

	closed: ZSTRING

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := Precursor (other) and then closed ~ other.closed
		end

feature {NONE} -- Implementation

	name_end_index: INTEGER
		do
			Result := open.count - 1
		end

feature {NONE} -- Constants

	Open_template: ZSTRING
		once
			Result := "<%S>"
		end

	Close_template: ZSTRING
		once
			Result := "</%S>"
		end
end

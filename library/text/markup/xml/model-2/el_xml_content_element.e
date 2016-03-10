note
	description: "Element containing either an element list or some text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 8:07:31 GMT (Wednesday 16th December 2015)"
	revision: "3"

deferred class
	EL_XML_CONTENT_ELEMENT

inherit
	EL_XML_EMPTY_ELEMENT
		rename
			open_slash_position as open_right_bracket_position
		undefine
			write
		redefine
			make, copy, is_equal, open_right_bracket_position
		end

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL)
		do
			Precursor (a_name)
			open.remove (open.count - 1)
			closed := new_tag (a_name, False)
		end

feature -- Access

	closed: ZSTRING

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := Precursor (other) and then closed ~ other.closed
		end

feature {NONE} -- Implementation

	open_right_bracket_position: INTEGER
		do
			Result := open.count
		end

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			Precursor (other)
			closed := other.closed.twin
		end
end

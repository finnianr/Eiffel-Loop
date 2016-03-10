note
	description: "[
		For example:
			<p>Some text</p>
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_XML_TEXT_ELEMENT

inherit
	EL_XML_CONTENT_ELEMENT
		redefine
			make, copy, is_equal
		end

create
	make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL)
		do
			Precursor (a_name)
			text := Empty_string
		end

feature -- Access

	text: ASTRING

feature -- Basic operations

	write (medium: EL_OUTPUT_MEDIUM)
		do
			medium.put_astring (open)
			medium.put_astring (text)
			medium.put_astring (closed)
			medium.put_new_line
		end

feature -- Element change

	set_text (a_text: like text)
		do
			text := a_text
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := Precursor (other) and then text ~ other.text
		end

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			Precursor (other)
			text := other.text.twin
		end

end

note
	description: "[
		A text XML element as for example:
		
			<p>Some text</p>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 15:39:40 GMT (Friday 8th January 2021)"
	revision: "8"

class
	EL_XML_TEXT_ELEMENT

inherit
	EL_XML_CONTENT_ELEMENT
		rename
			make as make_element
		redefine
			copy, is_equal
		end

create
	make, make_empty

convert
	make_empty ({STRING})

feature {NONE} -- Initialization

	make (a_name, a_text: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_ROUTINES
		do
			make_element (a_name)
			text := s.as_zstring (a_text)
		end

	make_empty (a_name: READABLE_STRING_GENERAL)
		do
			make_element (a_name)
			create text.make_empty
		end

feature -- Access

	text: ZSTRING

	to_string: ZSTRING
		do
			Result := buffer.copied (open)
			if internal_attribute_list.count > 0 then
				Result.remove_tail (1)
				across internal_attribute_list as list loop
					Result.append_character (' ')
					Result.append (list.item.to_string (False))
				end
				Result.append_character ('>')
			end
			Result.append (text)
			Result.append (closed)
		end

feature -- Basic operations

	write (medium: EL_OUTPUT_MEDIUM)
		do
			write_open_element (medium)
			write_text (medium)
			medium.put_string (closed)
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

feature {NONE} -- Implementation

	write_text (medium: EL_OUTPUT_MEDIUM)
		local
			escaper: like Xml_escaper
		do
			if medium.encoded_as_latin (1) then
				escaper := Xml_128_plus_escaper
			else
				escaper := Xml_escaper
			end
			medium.put_string (escaper.escaped (text, False))
		end

end
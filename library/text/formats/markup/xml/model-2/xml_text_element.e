note
	description: "[
		A text XML element as for example:
		
			<p>Some text</p>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-06 11:40:01 GMT (Wednesday 6th November 2024)"
	revision: "15"

class
	XML_TEXT_ELEMENT

inherit
	XML_CONTENT_ELEMENT
		rename
			make as make_element
		redefine
			copy, is_equal
		end

	EL_STRING_GENERAL_ROUTINES

create
	make, make_empty

convert
	make_empty ({STRING})

feature {NONE} -- Initialization

	make (a_name, a_text: READABLE_STRING_GENERAL)
		do
			make_element (a_name)
			text := as_zstring (a_text)
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
			if attached String_pool.borrowed_item as borrowed then
				if attached borrowed.empty as str then
					str.append (open)
					if attached actual_attribute_list as l_attribute_list and then l_attribute_list.count > 0 then
						str.remove_tail (1)
						across l_attribute_list as list loop
							str.append_character (' ')
							str.append (list.item.to_string (False))
						end
						str.append_character ('>')
					end
					str.append (text)
					str.append (closed)
					Result := str.twin
				end
				borrowed.return
			end
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
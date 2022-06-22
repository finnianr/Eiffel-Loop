note
	description: "XML element with list of nested elements"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-22 9:59:26 GMT (Wednesday 22nd June 2022)"
	revision: "6"

class
	XML_LIST_ELEMENT

inherit
	XML_CONTENT_ELEMENT
		redefine
			make, copy
		end

create
	make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL)
		do
			Precursor (a_name)
			create list.make_empty
		end

feature -- Access

	list: EL_ARRAYED_LIST [XML_ELEMENT]

feature -- Basic operations

	write (medium: EL_OUTPUT_MEDIUM)
		do
			write_indented (medium, "")
		end

feature -- Element change

	set_list (a_list: ITERABLE [XML_ELEMENT])
		do
			list.wipe_out
			list.append (a_list)
		end

feature {XML_LIST_ELEMENT} -- Implementation

	write_indented (medium: EL_OUTPUT_MEDIUM; indent: STRING)
		do
			medium.put_string_8 (indent)
			write_open_element (medium)
			if not list.is_empty then
				indent.append_character ('%T')
				medium.put_new_line
				across list as l loop
					if attached {XML_LIST_ELEMENT} l.item as list_elem then
						list_elem.write_indented (medium, indent)
					else
						medium.put_string_8 (indent)
						l.item.write (medium)
					end
				end
				indent.remove_tail (1)
			end
			medium.put_string_8 (indent)
			medium.put_string (closed)
			medium.put_new_line
		end

	copy (other: like Current)
		do
			Precursor (other)
			list := other.list.twin
		end

end



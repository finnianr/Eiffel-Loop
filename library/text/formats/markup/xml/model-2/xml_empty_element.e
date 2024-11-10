note
	description: "XML empty element"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 17:20:53 GMT (Sunday 10th November 2024)"
	revision: "23"

class
	XML_EMPTY_ELEMENT

inherit
	XML_ELEMENT
		redefine
			write, copy, is_equal
		end

	EL_LAZY_ATTRIBUTE
		rename
			new_item as new_attribute_list,
			cached_item as actual_attribute_list
		undefine
			copy, is_equal
		end

	EL_MODULE_ITERABLE

	XML_ZSTRING_CONSTANTS

	EL_SHARED_ZSTRING_BUFFER_POOL

create
	make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL)
		do
			open := Open_template #$ [a_name]
		end

feature -- Access

	attribute_list: like new_attribute_list
		do
			Result := lazy_item
		end

	name: ZSTRING
		do
			if open.count < 3 then
				create Result.make_empty
			else
				Result := open.substring (2, name_end_index)
			end
		end

	open: ZSTRING

feature -- Measurement

	attribute_count: INTEGER
		do
			if attached actual_attribute_list as list then
				Result := list.count
			end
		end

feature -- Basic operations

	write (medium: EL_OUTPUT_MEDIUM)
		do
			write_open_element (medium)
			medium.put_new_line
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := open ~ other.open
		end

feature -- Element change

	set_attributes_list (list: ITERABLE [XML_ELEMENT_ATTRIBUTE])
		do
			create actual_attribute_list.make_from_list (list)
		end

	set_attributes_from_string (csv_pair_list: STRING)
		local
			list: EL_STRING_8_LIST
		do
			list := csv_pair_list
			set_attributes_from_pairs (list)
		end

	set_attributes_from_pairs (nvp_list: ITERABLE [READABLE_STRING_GENERAL])
		require
			valid_attributes: across nvp_list as attrib all attrib.item.has ('=') end
		local
			new_list: like new_attribute_list
		do
			create new_list.make (Iterable.count (nvp_list))
			across nvp_list as nvp loop
				new_list.extend (create {XML_ELEMENT_ATTRIBUTE}.make_from_string (nvp.item))
			end
			actual_attribute_list := new_list
		end

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			if other /= Current then
				standard_copy (other)
				if other.attribute_count > 0 then
					actual_attribute_list := other.attribute_list.twin
				end
			end
		end

feature {NONE} -- Implementation

	name_end_index: INTEGER
		do
			Result := open.count - 2
		end

	new_attribute_list: EL_ARRAYED_LIST [XML_ELEMENT_ATTRIBUTE]
		do
			create Result.make (0)
		end

	write_open_element (medium: EL_OUTPUT_MEDIUM)
		local
			escaper: like Xml_escaper
		do
			if attribute_count > 0 then
				if attached String_pool.borrowed_item as borrowed then
					if attached borrowed.copied_substring (open, 1, name_end_index) as str then
						if medium.encoded_as_latin (1) then
							escaper := Xml_128_plus_escaper
						else
							escaper := Xml_escaper
						end
						if attached actual_attribute_list as l_attribute_list then
							across l_attribute_list as attrib loop
								str.append_character (' ')
								str.append (attrib.item.escaped (escaper, False))
							end
						end
						str.append_substring (open, name_end_index + 1, open.count)
						medium.put_string (str)
					end
					borrowed.return
				end
			else
				medium.put_string (open)
			end
		end

feature {NONE} -- Constants

	Escaped_quote: ZSTRING
		once
			Result := "&quot;"
		end

	Quote: ZSTRING
		once
			Result := "%""
		end

	Open_template: ZSTRING
		once
			Result := "<%S/>"
		end
end
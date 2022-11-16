note
	description: "XML empty element"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "18"

class
	XML_EMPTY_ELEMENT

inherit
	XML_ELEMENT
		redefine
			write, copy, is_equal
		end

	XML_ZSTRING_CONSTANTS

	EL_MODULE_ITERABLE

create
	make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL)
		do
			open := Open_template #$ [a_name]
			internal_attribute_list := Default_attribute_list
		end

feature -- Access

	attribute_list: like Default_attribute_list
		do
			Result := internal_attribute_list.twin
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
			Result := internal_attribute_list.count
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

	set_attributes_list (list: ITERABLE [like Default_attribute_list.item])
		do
			create internal_attribute_list.make (Iterable.count (list))
			across list as attrib loop
				internal_attribute_list.extend (attrib.item)
			end
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
			name_value_pair: like Default_attribute_list.item
		do
			create internal_attribute_list.make (Iterable.count (nvp_list))
			across nvp_list as nvp loop
				create name_value_pair.make_from_string (nvp.item)
				internal_attribute_list.extend (name_value_pair)
			end
		end

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			if other /= Current then
				standard_copy (other)
				if other.internal_attribute_list.count > 0 then
					internal_attribute_list := other.internal_attribute_list.twin
				end
			end
		end

feature {NONE} -- Implementation

	name_end_index: INTEGER
		do
			Result := open.count - 2
		end

	write_open_element (medium: EL_OUTPUT_MEDIUM)
		local
			l_string: ZSTRING; escaper: like Attribute_escaper
		do
			if attribute_count > 0 then
				l_string := buffer.copied_substring (open, 1, name_end_index)
				if medium.encoded_as_latin (1) then
					escaper := Attribute_128_plus_escaper
				else
					escaper := Attribute_escaper
				end
				across internal_attribute_list as attrib loop
					l_string.append_character (' ')
					l_string.append (attrib.item.escaped (escaper, False))
				end
				l_string.append_substring (open, name_end_index + 1, open.count)
				medium.put_string (l_string)
			else
				medium.put_string (open)
			end
		end

feature {XML_EMPTY_ELEMENT} -- Initialization

	internal_attribute_list: like Default_attribute_list

feature {NONE} -- Constants

	Default_attribute_list: EL_ARRAYED_LIST [XML_ELEMENT_ATTRIBUTE]
		once
			create Result.make (0)
		end

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

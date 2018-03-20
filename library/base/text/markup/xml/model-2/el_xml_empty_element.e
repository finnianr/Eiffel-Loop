note
	description: "Summary description for {EL_XML_TEXT_ELEMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-17 14:40:15 GMT (Saturday 17th February 2018)"
	revision: "3"

class
	EL_XML_EMPTY_ELEMENT

inherit
	EL_XML_ELEMENT
		redefine
			write, copy, is_equal
		end

	EL_XML_ESCAPING_CONSTANTS
		export
			{NONE} all
		undefine
			copy, is_equal
		end

create
	make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL)
		do
			open := new_tag (a_name, True)
			open.insert_character ('/', open.count)
		end

feature -- Access

	name: ZSTRING
		local
			pos_space: INTEGER
		do
			if open.item (open_slash_position) = '"' then
				pos_space := open.index_of (' ', 1)
				if pos_space > 0 then
					Result := open.substring (2, pos_space - 1)
				else
					create Result.make_empty
				end
			else
				Result := open.substring (2, open_slash_position - 1)
			end
		end

	open: ZSTRING

feature -- Basic operations

	write (medium: EL_OUTPUT_MEDIUM)
		do
			medium.put_string (open)
			medium.put_new_line
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := open ~ other.open
		end

feature -- Element change

	set_attributes (attributes: ARRAY [READABLE_STRING_GENERAL])
		require
			valid_attributes: across attributes as attrib all attrib.item.has ('=') end
		local
			count_extra: INTEGER; name_value_pair: ZSTRING
			escaped_attributes: EL_ZSTRING_LIST
		do
			create escaped_attributes.make (attributes.count)
			across attributes as attrib loop
				create name_value_pair.make (attrib.item.count + 2)
				name_value_pair.append_string_general (attrib.item)
				name_value_pair.escape (Attribute_escaper)
				name_value_pair.insert_character ('"', name_value_pair.index_of ('=', 1) + 1)
				name_value_pair.append_character ('"')
				count_extra := count_extra + name_value_pair.count + 1
				escaped_attributes.extend (name_value_pair)
			end
			if open [open_slash_position - 1] = '"' then
				open := new_tag (name, True)
				open.insert_character ('/', open.count)
			end
			open.grow (count_extra)
			across escaped_attributes as attrib loop
				open.insert_character (' ', open_slash_position)
				open.insert_string (attrib.item, open_slash_position)
			end
		end

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			open := other.open.twin
		end

feature {NONE} -- Implementation

	open_slash_position: INTEGER
		do
			Result := open.count - 1
		end

	new_tag (a_name: READABLE_STRING_GENERAL; is_open: BOOLEAN): ZSTRING
		local
			count: INTEGER
		do
			if is_open then
				count := a_name.count + 2
			else
				count := a_name.count + 3
			end
			create Result.make (count)
			Result.append_character (Left_bracket)
			if not is_open then
				Result.append_character ('/')
			end
			Result.append_string_general (a_name)
			Result.append_character (Right_bracket)
		end

feature {NONE} -- Constants

	Empty_attributes: ARRAY [READABLE_STRING_GENERAL]
		once
			create Result.make_empty
		end

	Escaped_quote: ZSTRING
		once
			Result := "&quot;"
		end

	Left_bracket: CHARACTER
		once
			Result := '<'
		end

	Quote: ZSTRING
		once
			Result := "%""
		end

	Right_bracket: CHARACTER
		once
			Result := '>'
		end

end

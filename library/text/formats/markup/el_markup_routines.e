note
	description: "Markup routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 15:24:49 GMT (Wednesday 2nd August 2023)"
	revision: "15"

class
	EL_MARKUP_ROUTINES

inherit
	ANY

	XML_ZSTRING_CONSTANTS

	EL_MODULE_REUSEABLE

feature -- Access

	numbered_tag_list (base_name: READABLE_STRING_GENERAL; lower, upper: INTEGER): EL_ARRAYED_LIST [XML_TAG]
		local
			i: INTEGER; name: ZSTRING
		do
			create Result.make (upper - lower + 1)
			create name.make (base_name.count + 1)
			from i := 1 until i > upper loop
				name.wipe_out
				name.append_string_general (base_name)
				name.append_integer (i)
				Result.extend (tag (name))
				i := i + 1
			end
		end

	tag_list (string_list: READABLE_STRING_GENERAL): EL_ARRAYED_LIST [XML_TAG]
		local
			list: EL_ZSTRING_LIST
		do
			create list.make_comma_split (string_list)
			create Result.make (list.count)
			across list as name loop
				Result.extend (tag (name.item))
			end
		end

feature -- Basic operations

	append_open_tag (output: ZSTRING; name: READABLE_STRING_GENERAL)
		do
			output.append (Bracket.left)
			output.append_string_general (name)
			output.append (Bracket.right)
		end

	append_close_tag (output: ZSTRING; name: READABLE_STRING_GENERAL)
		do
			output.append (Bracket.left_slash) -- </
			output.append_string_general (name)
			output.append (Bracket.right)
		end

feature -- Mark up

	closed_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- closed tag markup: </%S>
		do
			create Result.make (name.count + 3)
			append_close_tag (Result, name)
		end

	empty_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- empty tag markup: <%S/>
		do
			create Result.make (name.count + 3)
			append_open_tag (Result, name)
			Result.insert_character ('/', Result.count)
		end

	open_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- open tag markup: <%S>
		do
			create Result.make (name.count + 2)
			append_open_tag (Result, name)
		end

	parent_element_markup (name, element_list: READABLE_STRING_GENERAL): ZSTRING
			-- Wrap a list of elements with a parent element
		do
			create Result.make (name.count + element_list.count + 7)
			append_open_tag (Result, name)
			Result.append_character ('%N')
			Result.append_string_general (element_list)
			append_close_tag (Result, name)
			Result.append_character ('%N')
		end

	tag (name: READABLE_STRING_GENERAL): XML_TAG
		do
			create Result.make (name)
		end

	expanded_field_element (
		name: READABLE_STRING_GENERAL; object: EL_REFLECTIVE; field: EL_REFLECTED_EXPANDED_FIELD [ANY]
	): ZSTRING
			-- Enclose a value inside matching element tags
		local
			count: INTEGER
		do
			create Result.make (name.count + 20)
			count := Result.count
			Result.append (open_tag (name))
			field.append_to_string (object, Result)
			if Result.count = count then
				Result.insert_character ('/', Result.count)
			end
		end

	value_element (
		name, value: READABLE_STRING_GENERAL; a_escaper: detachable EL_STRING_ESCAPER [ZSTRING]
	): ZSTRING
			-- Enclose a value inside matching element tags
		do
			create Result.make (name.count + value.count + 6)
			Result.append (open_tag (name))
			if value.count > 0 then
				if attached a_escaper as escaper then
					escaper.escape_into (value, Result)

				else
					Result.append_string_general (value)
				end
				Result.append (closed_tag (name))
			else
				Result.insert_character ('/', Result.count)
			end
		end

end
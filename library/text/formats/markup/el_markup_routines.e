note
	description: "Markup routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-18 8:25:19 GMT (Sunday 18th June 2023)"
	revision: "14"

class
	EL_MARKUP_ROUTINES

inherit
	ANY

	EL_MARKUP_TEMPLATES
		rename
			Tag as Tag_template
		end

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

feature -- Mark up

	closed_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- closed tag markup: </%S>
		do
			Result := Tag_template.close #$ [name]
		end

	empty_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- empty tag markup: <%S/>
		do
			Result := Tag_template.empty #$ [name]
		end

	open_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- open tag markup: <%S>
		do
			Result := Tag_template.open #$ [name]
		end

	parent_element_markup (name, element_list: READABLE_STRING_GENERAL): ZSTRING
			-- Wrap a list of elements with a parent element
		do
			create Result.make (name.count + element_list.count + 7)
			Result.append (open_tag (name))
			Result.append_character ('%N')
			Result.append_string_general (element_list)
			Result.append (closed_tag (name))
			Result.append_character ('%N')
		end

	tag (name: READABLE_STRING_GENERAL): XML_TAG
		do
			create Result.make (name)
		end

	value_element_markup (name, value: READABLE_STRING_GENERAL): ZSTRING
			-- Enclose a value inside matching element tags
		do
			create Result.make (name.count + value.count + 6)
			Result.append (open_tag (name))
			Result.append_string_general (value)
			Result.append (closed_tag (name))
		end

end
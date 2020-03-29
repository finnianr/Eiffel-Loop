note
	description: "Markup routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-29 10:36:40 GMT (Sunday 29th March 2020)"
	revision: "8"

class
	EL_MARKUP_ROUTINES

inherit
	EL_MARKUP_TEMPLATES

	EL_MODULE_ZSTRING

feature -- Access

	numbered_tag_list (base_name: READABLE_STRING_GENERAL; lower, upper: INTEGER): EL_ARRAYED_LIST [EL_XML_TAG]
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

	tag_list (string_list: READABLE_STRING_GENERAL): EL_ARRAYED_LIST [EL_XML_TAG]
		local
			list: EL_ZSTRING_LIST
		do
			create list.make_with_csv (string_list)
			create Result.make (list.count)
			across list as name loop
				Result.extend (tag (name.item))
			end
		end

feature -- Mark up

	closed_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- closed tag markup
		do
			Result := Tag_close #$ [name]
		end

	empty_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- empty tag markup
		do
			Result := Tag_empty #$ [name]
		end

	open_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- open tag markup
		do
			Result := Tag_open #$ [name]
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

	tag (name: READABLE_STRING_GENERAL): EL_XML_TAG
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

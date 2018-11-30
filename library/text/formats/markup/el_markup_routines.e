note
	description: "Markup routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-16 20:17:52 GMT (Friday 16th November 2018)"
	revision: "6"

class
	EL_MARKUP_ROUTINES

inherit
	EL_MARKUP_TEMPLATES

feature -- Mark up

	open_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- open tag markup
		do
			Result := Tag_open #$ [name]
		end

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

end

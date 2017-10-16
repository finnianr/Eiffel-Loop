note
	description: "Summary description for {EL_MARKUP_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "3"

class
	EL_MARKUP_ROUTINES

feature -- Mark up

	open_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- open tag markup
		do
			create Result.make_from_general (once "<" + name + once ">")
		end

	closed_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- closed tag markup
		do
			create Result.make_from_general (once "</" + name + once ">")
		end

	empty_tag (name: READABLE_STRING_GENERAL): ZSTRING
			-- empty tag markup
		do
			create Result.make_from_general (once "<" + name + once "/>")
		end

	tag (name: READABLE_STRING_GENERAL): TUPLE [open, closed: ZSTRING]
		do
			Result := [open_tag (name), closed_tag (name)]
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

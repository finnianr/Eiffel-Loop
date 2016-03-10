note
	description: "Summary description for {EL_MARKUP_ROUTINES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_MARKUP_ROUTINES

feature -- Mark up

	open_tag (name: READABLE_STRING_GENERAL): ASTRING
			-- open tag markup
		do
			create Result.make_from_unicode (once "<" + name + once ">")
		end

	closed_tag (name: READABLE_STRING_GENERAL): ASTRING
			-- closed tag markup
		do
			create Result.make_from_unicode (once "</" + name + once ">")
		end

	empty_tag (name: READABLE_STRING_GENERAL): ASTRING
			-- empty tag markup
		do
			create Result.make_from_unicode (once "<" + name + once "/>")
		end

	tag (name: READABLE_STRING_GENERAL): TUPLE [open, closed: ASTRING]
		do
			Result := [open_tag (name), closed_tag (name)]
		end

	value_element_markup (name, value: READABLE_STRING_GENERAL): ASTRING
			-- Enclose a value inside matching element tags
		do
			create Result.make (name.count + value.count + 6)
			Result.append (open_tag (name))
			Result.append_string (value)
			Result.append (closed_tag (name))
		end

	parent_element_markup (name, element_list: READABLE_STRING_GENERAL): ASTRING
			-- Wrap a list of elements with a parent element
		do
			create Result.make (name.count + element_list.count + 7)
			Result.append (open_tag (name))
			Result.append_character ('%N')
			Result.append_string (element_list)
			Result.append (closed_tag (name))
			Result.append_character ('%N')
		end

end

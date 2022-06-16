note
	description: "Evolicity xml escaped context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-14 11:22:26 GMT (Tuesday 14th June 2022)"
	revision: "5"

deferred class
	EVOLICITY_REFLECTIVE_XML_CONTEXT

inherit
	EL_SHARED_CLASS_ID

	EL_REFLECTION_HANDLER

feature {NONE} -- Implementation

	current_reflective: EL_REFLECTIVE
		deferred
		end

	escaped_field (a_string: READABLE_STRING_GENERAL; type_id: INTEGER): READABLE_STRING_GENERAL
		do
			if XML_escaper_by_type.has_key (type_id) then
				Result := XML_escaper_by_type.found_item.escaped (a_string, False)
			end
		end

	xml_element_list_template: STRING
		-- rename `template' from `EVOLICITY_REFLECTIVE_SERIALIZEABLE' to this function
		-- to get XML serialization template
		local
			list: EL_STRING_8_LIST
		do
			create list.make (current_reflective.field_table.count)
			across current_reflective.field_table as table loop
				if attached table.item.export_name as tag_name then
					list.extend (Element_template #$ [tag_name, table.key, tag_name])
				end
			end
			Result := list.joined_lines
		end

feature {NONE} -- Constants

	XML_escaper_by_type: EL_HASH_TABLE [EL_XML_GENERAL_ESCAPER, INTEGER]
		once
			create Result.make (<<
				[Class_id.ZSTRING, create {EL_XML_ZSTRING_ESCAPER}.make],
				[Class_id.STRING_8, create {EL_XML_STRING_8_ESCAPER}.make],
				[Class_id.STRING_32, create {EL_XML_STRING_32_ESCAPER}.make]
			>>)
		end

	Element_template: ZSTRING
		once
			Result := "<%S>$%S</%S>"
		end

end
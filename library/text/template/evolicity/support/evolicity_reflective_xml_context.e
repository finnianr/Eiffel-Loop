note
	description: "Evolicity xml escaped context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-13 10:41:43 GMT (Tuesday 13th November 2018)"
	revision: "2"

deferred class
	EVOLICITY_REFLECTIVE_XML_CONTEXT

inherit
	EL_REFLECTOR_CONSTANTS

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
			table: like current_reflective.field_table
			list: EL_STRING_8_LIST; tag_name: STRING
		do
			table := current_reflective.field_table
			create list.make (table.count)
			across table.current_keys as name loop
				tag_name := current_reflective.export_name (name.item, False)
				list.extend (Element_template #$ [tag_name, name.item, tag_name])
			end
			Result := list.joined_lines
		end

feature {NONE} -- Constants

	XML_escaper_by_type: EL_HASH_TABLE [EL_XML_GENERAL_ESCAPER, INTEGER]
		once
			create Result.make (<<
				[String_z_type, create {EL_XML_ZSTRING_ESCAPER}.make],
				[String_8_type, create {EL_XML_STRING_8_ESCAPER}.make],
				[String_32_type, create {EL_XML_STRING_32_ESCAPER}.make]
			>>)
		end

	Element_template: ZSTRING
		once
			Result := "<%S>$%S</%S>"
		end

end

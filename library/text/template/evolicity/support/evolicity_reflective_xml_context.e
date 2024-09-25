note
	description: "Evolicity XML escaped context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 13:29:37 GMT (Monday 23rd September 2024)"
	revision: "12"

deferred class
	EVOLICITY_REFLECTIVE_XML_CONTEXT

inherit
	EL_SHARED_CLASS_ID

	EL_REFLECTION_HANDLER

feature {NONE} -- Implementation

	current_reflective: EL_REFLECTIVE
		deferred
		end

	escaped_field (a_string: READABLE_STRING_GENERAL; type_id: INTEGER): STRING_GENERAL
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
--					list.extend (Element_template #$ [tag_name, table.key, tag_name])
				end
			end
			Result := list.joined_lines
		end

feature {NONE} -- Constants

	XML_escaper_by_type: EL_HASH_TABLE [XML_ESCAPER [STRING_GENERAL], INTEGER]
		once
			create Result.make_assignments (<<
				[Class_id.ZSTRING, create {XML_ESCAPER [ZSTRING]}.make],
				[Class_id.STRING_8, create {XML_ESCAPER [STRING_8]}.make],
				[Class_id.STRING_32, create {XML_ESCAPER [STRING_32]}.make]
			>>)
		end

end
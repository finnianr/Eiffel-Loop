note
	description: "Evolicity XML escaped context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 14:45:10 GMT (Saturday 22nd March 2025)"
	revision: "14"

deferred class
	EVC_REFLECTIVE_XML_CONTEXT

inherit
	EL_MODULE_XML

	EL_REFLECTION_HANDLER

	EL_SHARED_ZSTRING_BUFFER_POOL

	XML_ZSTRING_CONSTANTS

feature {NONE} -- Implementation

	current_reflective: EL_REFLECTIVE
		deferred
		end

	escaped_field (a_string: READABLE_STRING_GENERAL; type_id: INTEGER): STRING_GENERAL
		do
			Result := XML.escaper (type_id).escaped (a_string, True)
		end

	xml_element_list: EL_ZSTRING_LIST
		-- list of all field values as XML text elements
		-- Format: <$field.export_name>$field.to_string</$field.export_name>
		do
			create Result.make (current_reflective.field_table.count)
			if attached String_pool.borrowed_batch (2) as borrowed
				and then attached borrowed [0].empty as buffer
				and then attached borrowed [1].empty as field_string
			then
				across current_reflective.field_list as list loop
					buffer.wipe_out; field_string.wipe_out
					if attached list.item as field then
						XML.append_open_tag (buffer, field.export_name)
						field.append_to_string (current_reflective, field_string)
						Xml_escaper.escape_into (field_string, buffer)
						XML.append_close_tag (buffer, field.export_name)
					end
					Result.extend (buffer.twin)
				end
				String_pool.return (borrowed)
			end
		end

end
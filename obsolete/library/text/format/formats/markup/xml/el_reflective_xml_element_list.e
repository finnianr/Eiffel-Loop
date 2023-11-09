note
	description: "Reflective XML element list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 9:56:37 GMT (Wednesday 8th November 2023)"
	revision: "2"

class
	EL_REFLECTIVE_XML_ELEMENT_LIST [G]

obsolete
	"Unused, unfinished and untested class"

inherit
	EL_ZSTRING_LIST
		rename
			make as make_sized
		end

	EL_MODULE_XML

	EL_SHARED_ZSTRING_BUFFER_SCOPES

create
	make, make_exported, make_conforming, make_conforming_exported

feature {NONE} -- Initialization

	make (object: EL_REFLECTIVE; to_string: detachable FUNCTION [G, READABLE_STRING_GENERAL])
		do
			make_with_criteria (object, False, False, to_string)
		end

	make_conforming (object: EL_REFLECTIVE; to_string: detachable FUNCTION [G, READABLE_STRING_GENERAL])
		do
			make_with_criteria (object, True, False, to_string)
		end

	make_conforming_exported (object: EL_REFLECTIVE; to_string: detachable FUNCTION [G, READABLE_STRING_GENERAL])
		do
			make_with_criteria (object, True, True, to_string)
		end

	make_exported (object: EL_REFLECTIVE; to_string: detachable FUNCTION [G, READABLE_STRING_GENERAL])
		do
			make_with_criteria (object, False, True, to_string)
		end

	make_with_criteria (
		object: EL_REFLECTIVE; conforming_types, exported_name: BOOLEAN
		to_string: detachable FUNCTION [G, READABLE_STRING_GENERAL]
	)
		local
			type_query: EL_FIELD_TYPE_QUERY [G]
		do
			create type_query.make (object, conforming_types)
			if attached type_query.reference_fields as field_list then
				make_sized (field_list.count)
				across String_scope as scope loop
					if attached scope.item as line then
						across field_list as list loop
							line.wipe_out
							if attached list.item as field then
								XML.append_open_tag (line, type_query.field_name (field, exported_name))
								if attached to_string as as_string and then attached {G} field.value (object) as value then

								end
								XML.append_close_tag (line, type_query.field_name (field, exported_name))
							end
						end
					end
				end

			elseif attached type_query.expanded_fields as field_list then
				make_sized (field_list.count)
				across field_list as list loop
					if attached list.item as field then
						extend (XML.expanded_field_element (type_query.field_name (field, exported_name), object, field))
					end
				end
			end
		end

end

note
	description: "Evolicity xml escaped context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-31 11:24:14 GMT (Wednesday 31st October 2018)"
	revision: "1"

class
	EVOLICITY_XML_ESCAPED_CONTEXT

inherit
	EL_REFLECTOR_CONSTANTS

feature {NONE} -- Implementation

	escaped_field (a_string: READABLE_STRING_GENERAL; type_id: INTEGER): READABLE_STRING_GENERAL
		do
			if XML_escaper_by_type.has_key (type_id) then
				Result := XML_escaper_by_type.found_item.escaped (a_string, False)
			end
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
end

note
	description: "[
		Default implementation of ${EL_SERIALIZEABLE_AS_XML}
		
		**to_xml:**
		
			<?xml version="1.0" encoding="UTF-8"?>
			<default/>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "11"

class
	EL_DEFAULT_SERIALIZEABLE_XML

inherit
	EL_SERIALIZEABLE_AS_XML

	EL_MODULE_XML

	EL_CHARACTER_8_CONSTANTS

feature -- Conversion

	to_xml: STRING
			--
		do
			Result := new_line.joined (XML.header (1.0, {CODE_PAGE_CONSTANTS}.Utf8).to_latin_1, "<default/>")
		end

end
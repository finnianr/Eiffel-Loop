note
	description: "[
		Default implementation of [$source EL_SERIALIZEABLE_AS_XML]
		
		**to_xml:**
		
			<?xml version="1.0" encoding="UTF-8"?>
			<default/>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-14 8:50:02 GMT (Friday 14th July 2023)"
	revision: "8"

class
	EL_DEFAULT_SERIALIZEABLE_XML

inherit
	EL_SERIALIZEABLE_AS_XML

feature -- Conversion

	to_xml: STRING
			--
		do
			Result := Default_xml
		end

feature {NONE} -- Constants

	Default_xml: STRING = "[
		<?xml version="1.0" encoding="UTF-8"?>
		<default/>
	]"

end
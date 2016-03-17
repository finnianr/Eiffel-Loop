note
	description: "Summary description for {EL_SERIALIZEABLE_AS_XML}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:35:02 GMT (Wednesday 16th December 2015)"
	revision: "3"

deferred class
	EL_SERIALIZEABLE_AS_XML

feature -- Conversion

	to_xml: ZSTRING
			--
		deferred
		end

	to_utf_8_xml: STRING
			--
		deferred
		end

end

note
	description: "Serializeable as xml"
	notes: "[
		This class was a candidate for inclusion in `text-formats.ecf' but then it created
		a circular dependency with `evolicity.ecf' and `os-command.ecf'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-27 14:02:36 GMT (Thursday 27th September 2018)"
	revision: "5"

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

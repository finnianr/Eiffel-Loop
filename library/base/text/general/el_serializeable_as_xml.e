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
	date: "2020-11-23 10:35:24 GMT (Monday 23rd November 2020)"
	revision: "6"

deferred class
	EL_SERIALIZEABLE_AS_XML

feature -- Conversion

	to_xml: STRING
			--
		deferred
		end

end
note
	description: "Serializeable as xml"
	notes: "[
		This class was a candidate for inclusion in `text-formats.ecf' but then it created
		a circular dependency with `evolicity.ecf' and `os-command.ecf'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_SERIALIZEABLE_AS_XML

feature -- Conversion

	to_xml: STRING
			--
		deferred
		end

end
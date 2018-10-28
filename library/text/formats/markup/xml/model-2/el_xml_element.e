note
	description: "Xml element"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 13:31:06 GMT (Wednesday 17th October 2018)"
	revision: "6"

deferred class
	EL_XML_ELEMENT

inherit
	EL_MODULE_XML

	EL_ZSTRING_CONSTANTS

feature -- Access

	name: ZSTRING
		deferred
		end

feature -- Basic operations

	write (medium: EL_OUTPUT_MEDIUM)
		deferred
		end

end
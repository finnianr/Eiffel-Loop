note
	description: "Xml element"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

deferred class
	EL_XML_ELEMENT

inherit
	EL_MODULE_XML

	EL_STRING_CONSTANTS

feature -- Access

	name: ZSTRING
		deferred
		end

feature -- Basic operations

	write (medium: EL_OUTPUT_MEDIUM)
		deferred
		end

end
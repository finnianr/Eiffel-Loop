note
	description: "Summary description for {EL_XML_ELEMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 8:07:48 GMT (Wednesday 16th December 2015)"
	revision: "3"

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
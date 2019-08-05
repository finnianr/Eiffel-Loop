note
	description: "Xml element"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 12:01:56 GMT (Monday 5th August 2019)"
	revision: "7"

deferred class
	EL_XML_ELEMENT

inherit
	ANY
	
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

note
	description: "[
		Object that applies XML parse events to the construction of an object
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_XML_NODE_SCAN_SOURCE

inherit
	EL_XML_DOCUMENT_SCANNER

feature -- Basic operations

	apply_from_stream (a_object: like seed_object; a_stream: IO_MEDIUM)
			--
		do
			set_seed_object (a_object)
			scan_from_stream (a_stream)
		end

	apply_from_string (a_object: like seed_object; a_str: STRING)
			--
		do
			set_seed_object (a_object)
			scan (a_str)
		end

feature -- Element change

	set_seed_object (a_object: like seed_object)
			--
		do
			seed_object := a_object
		end

feature {NONE} -- Implementation

	seed_object: EL_CREATEABLE_FROM_XML

end

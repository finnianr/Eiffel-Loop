note
	description: "Summary description for {EL_XML_TO_EIFFEL_OBJECT_BUILDER_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_XML_TO_EIFFEL_OBJECT_BUILDER_I

feature -- Basic operations

	build_from_stream (target_object: EL_BUILDABLE_FROM_XML; a_stream: IO_MEDIUM)
			-- Build target from xml stream
		deferred
		end

	build_from_string (target_object: EL_BUILDABLE_FROM_XML; a_str: STRING)
			-- Build target from xml string
		deferred
		end

end
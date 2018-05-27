note
	description: "Xml to eiffel object builder i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:49 GMT (Saturday 19th May 2018)"
	revision: "4"

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
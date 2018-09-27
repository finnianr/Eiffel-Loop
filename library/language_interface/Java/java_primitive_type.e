note
	description: "Java primitive type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

deferred class
	JAVA_PRIMITIVE_TYPE [EIF_EQUIVALENT]

inherit
	JAVA_TYPE

	JAVA_TO_EIFFEL_CONVERTABLE [EIF_EQUIVALENT]

	JAVA_SHARED_ORB

feature -- Access

	value: EIF_EQUIVALENT

end -- class JAVA_PRIMITIVE_TYPE
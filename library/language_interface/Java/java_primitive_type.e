note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	JAVA_PRIMITIVE_TYPE [EIF_EQUIVALENT]

inherit
	JAVA_TYPE

	JAVA_TO_EIFFEL_CONVERTABLE [EIF_EQUIVALENT]

	JAVA_SHARED_ORB

feature -- Access

	value: EIF_EQUIVALENT

end -- class JAVA_PRIMITIVE_TYPE
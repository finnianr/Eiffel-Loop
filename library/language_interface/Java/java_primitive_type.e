note
	description: "Java primitive type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	JAVA_PRIMITIVE_TYPE [EIF_EQUIVALENT]

inherit
	JAVA_TYPE

	JAVA_TO_EIFFEL_CONVERTABLE [EIF_EQUIVALENT]

	JAVA_SHARED_ORB

feature -- Access

	value: EIF_EQUIVALENT

end -- class JAVA_PRIMITIVE_TYPE
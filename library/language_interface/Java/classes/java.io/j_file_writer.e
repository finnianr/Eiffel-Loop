note
	description: "Interface to Java class: `java.io.svg.FileWriter'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	J_FILE_WRITER

inherit
	J_OUTPUT_STREAM_WRITER

create
	default_create,
	make_from_java_method_result, make_from_java_attribute,	make_from_string

feature {NONE} -- Initialization

	make_from_string (s: J_STRING)
			--
		do
			make_from_pointer (jagent_make_from_string.java_object_id (Current, [s]))
		end

feature {NONE} -- Implementation

	jagent_make_from_string: JAVA_CONSTRUCTOR
			--
		once
			create Result.make (agent make_from_string)
		end

end
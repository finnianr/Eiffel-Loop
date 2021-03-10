note
	description: "Interface to Java class: `java.io.svg.FileWriter'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 15:49:54 GMT (Wednesday 10th March 2021)"
	revision: "5"

class
	J_FILE_WRITER

inherit
	J_OUTPUT_STREAM_WRITER
		undefine
			Jclass
		end

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

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "FileWriter")
		end

end
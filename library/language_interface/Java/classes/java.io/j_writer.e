note
	description: "Interface to Java class: `java.io.svg.Writer'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 15:05:04 GMT (Wednesday 10th March 2021)"
	revision: "5"

class
	J_WRITER

inherit
	JAVA_IO_JPACKAGE

	J_OBJECT
		undefine
			Package_name
		end

create
	default_create,
	make, make_from_pointer,
	make_from_java_method_result, make_from_java_attribute

end
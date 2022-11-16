note
	description: "Interface to Java class: `java.io.svg.Writer'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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
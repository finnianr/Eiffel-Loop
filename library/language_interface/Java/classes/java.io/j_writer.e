note
	description: "J writer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	J_WRITER

inherit
	JAVA_IO_JPACKAGE

	J_OBJECT
		undefine
			Jclass, Package_name
		end

create
	default_create,
	make, make_from_pointer,
	make_from_java_method_result, make_from_java_attribute

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "Writer")
		end

end -- class J_WRITER
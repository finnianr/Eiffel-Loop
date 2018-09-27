note
	description: "J file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	J_FILE

inherit
	JAVA_IO_JPACKAGE

	J_OBJECT
		undefine
			Jclass, Package_name
		end

create
	default_create,
	make, make_from_pointer,
	make_from_java_method_result, make_from_java_attribute, make_from_string

feature {NONE} -- Initialization

	make_from_string (s: J_STRING)
			--
		do
			make_from_pointer (jagent_make_from_string.java_object_id (Current, [s]))
		end

feature {NONE} -- Implementation

	jagent_make_from_string: JAVA_CONSTRUCTOR [J_FILE]
			--
		once
			create Result.make (agent make_from_string)
		end

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "File")
		end

end
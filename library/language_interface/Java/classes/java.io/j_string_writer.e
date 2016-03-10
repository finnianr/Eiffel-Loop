note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2011-07-24 9:48:02 GMT (Sunday 24th July 2011)"
	revision: "1"

class
	J_STRING_WRITER

inherit
	J_WRITER
		undefine
			Jclass
		end

create
	default_create,
	make, make_from_pointer,
	make_from_java_method_result, make_from_java_attribute

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "StringWriter")
		end

end -- class J_STRING_WRITER

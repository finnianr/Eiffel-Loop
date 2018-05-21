note
	description: "J context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:02 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	J_CONTEXT

inherit
	ORG_APACHE_VELOCITY_CONTEXT_JPACKAGE

	JAVA_OBJECT_REFERENCE

create
	default_create,
	make, make_from_pointer,
	make_from_java_method_result, make_from_java_attribute

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "Context")
		end


end -- class J_CONTEXT
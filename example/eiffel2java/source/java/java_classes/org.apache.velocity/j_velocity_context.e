note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:16 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	J_VELOCITY_CONTEXT

inherit
	ORG_APACHE_VELOCITY_JPACKAGE

	J_CONTEXT
		undefine
			Package_name, Jclass
		end

create
	default_create,
	make, make_from_pointer,
	make_from_java_method_result, make_from_java_attribute

feature -- Element change

	put_string (key: J_STRING; str: J_STRING): J_OBJECT
			--
		do
			Result := put (key, str)
		end

	put_object (key: J_STRING; object: J_OBJECT): J_OBJECT
			--
		do
			Result := put (key, object)
		end

	put (key: J_STRING; object: J_OBJECT): J_OBJECT
			--
		do
			Result := jagent_put.item (Current, [key, object])
		end

feature {NONE} -- Implementation

	jagent_put: JAVA_FUNCTION [J_VELOCITY_CONTEXT, J_OBJECT]
			--
		once
			create Result.make ("put", agent put)
		end

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "VelocityContext")
		end

end -- class J_VELOCITY_CONTEXT

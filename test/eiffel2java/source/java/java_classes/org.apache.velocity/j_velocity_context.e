note
	description: "Interface to Java class: `org.apache.velocity.VelocityContext'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	J_VELOCITY_CONTEXT

inherit
	J_OBJECT
		undefine
			Package_name
		end

	J_CONTEXT
		undefine
			Package_name
		end

	ORG_APACHE_VELOCITY_JPACKAGE

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
			Result := Jagent_put.item (Current, [key, object])
		end

feature {NONE} -- Constants

	Jagent_put: JAVA_FUNCTION [J_OBJECT]
			--
		once
			create Result.make ("put", agent put)
		end

end
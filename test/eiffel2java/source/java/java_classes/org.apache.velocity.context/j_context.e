note
	description: "Interface to Java interface: `org.apache.velocity.context.Context'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	J_CONTEXT

inherit
	ORG_APACHE_VELOCITY_CONTEXT_JPACKAGE

	JAVA_OBJECT_REFERENCE

create
	default_create, make, make_from_pointer,
	make_from_java_method_result, make_from_java_attribute

end
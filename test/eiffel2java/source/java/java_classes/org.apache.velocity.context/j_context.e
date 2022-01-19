note
	description: "Interface to Java interface: `org.apache.velocity.context.Context'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 15:01:06 GMT (Wednesday 10th March 2021)"
	revision: "5"

class
	J_CONTEXT

inherit
	ORG_APACHE_VELOCITY_CONTEXT_JPACKAGE

	JAVA_OBJECT_REFERENCE

create
	default_create, make, make_from_pointer,
	make_from_java_method_result, make_from_java_attribute

end
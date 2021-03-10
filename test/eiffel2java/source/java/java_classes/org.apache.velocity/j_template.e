note
	description: "Interface to Java class: `org.apache.velocity.Template'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 20:26:10 GMT (Monday 13th January 2020)"
	revision: "5"

class
	J_TEMPLATE

inherit
	J_OBJECT
		undefine
			Package_name
		end

	ORG_APACHE_VELOCITY_JPACKAGE

create
	default_create,
	make,
	make_from_pointer,
	make_from_java_method_result,
	make_from_java_attribute

feature -- Access

	merge (context: J_CONTEXT; writer: J_WRITER)
			--
		do
			jagent_merge.call (Current, [context, writer])
		end

feature {NONE} -- Implementation

	jagent_merge: JAVA_PROCEDURE
			--
		once
			create Result.make ("merge", agent merge)
		end

end

note
	description: "Interface to Java class: `org.apache.velocity.Template'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "7"

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
			Jagent_merge.call (Current, [context, writer])
		end

feature {NONE} -- Constants

	Jagent_merge: JAVA_PROCEDURE
			--
		once
			create Result.make ("merge", agent merge)
		end

end
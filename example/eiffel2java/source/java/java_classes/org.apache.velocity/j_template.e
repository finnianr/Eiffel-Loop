note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:16 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	J_TEMPLATE

inherit
	ORG_APACHE_VELOCITY_JPACKAGE

	JAVA_OBJECT_REFERENCE

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
			log.enter ("merge")
			jagent_merge.call (Current, [context, writer])
			log.exit
		end

feature {NONE} -- Implementation

	jagent_merge: JAVA_PROCEDURE [J_TEMPLATE]
			--
		once
			create Result.make ("merge", agent merge)
		end

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "Template")
		end

end -- class J_TEMPLATE

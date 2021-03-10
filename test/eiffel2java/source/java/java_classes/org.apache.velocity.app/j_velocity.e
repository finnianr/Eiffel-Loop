note
	description: "Interface to Java class: `org.apache.velocity.app.VelocityContext'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 20:26:10 GMT (Monday 13th January 2020)"
	revision: "6"

class
	J_VELOCITY

inherit
	J_OBJECT
		undefine
			Package_name
		end

	ORG_APACHE_VELOCITY_APP_JPACKAGE

create
	default_create,
	make, make_from_pointer,
	make_from_java_method_result, make_from_java_attribute

feature -- Commands

	init
			--
		do
			jagent_init.call (Current, [])
		end

feature -- Access

	template (name: J_STRING): J_TEMPLATE
			--
		do
			Result := jagent_template.item (Current, [name])
		end

feature {NONE} -- Implementation

	jagent_template: JAVA_STATIC_FUNCTION [J_TEMPLATE]
			--
		once
			create Result.make ("getTemplate", agent template)
		end

feature {NONE} -- Java agents

	jagent_init: JAVA_STATIC_PROCEDURE
			--
		once
			create Result.make ("init", agent init)
		end

end

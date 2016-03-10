note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:16 GMT (Thursday 11th December 2014)"
	revision: "2"

deferred class
	ORG_APACHE_VELOCITY_CONTEXT_JPACKAGE

inherit
	JAVA_PACKAGE

feature -- Constant
	Package_name: STRING
		once
			Result := "org.apache.velocity.context"
		end

end -- class ORG_APACHE_VELOCITY_CONTEXT_JPACKAGE

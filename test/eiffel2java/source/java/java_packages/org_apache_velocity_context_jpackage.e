note
	description: "Java package: `org.apache.velocity.context'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 16:14:50 GMT (Wednesday 10th March 2021)"
	revision: "5"

deferred class
	ORG_APACHE_VELOCITY_CONTEXT_JPACKAGE

inherit
	JAVA_PACKAGE

feature -- Constant

	Package_name: STRING
		once
			Result := "org.apache.velocity.context"
		end

end
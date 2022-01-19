note
	description: "Java package: `org.apache.velocity'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 8:27:20 GMT (Wednesday 10th March 2021)"
	revision: "5"

deferred class
	ORG_APACHE_VELOCITY_JPACKAGE

inherit
	JAVA_PACKAGE

feature -- Constant

	Package_name: STRING
			--
		once
			Result := "org.apache.velocity"
		end

end
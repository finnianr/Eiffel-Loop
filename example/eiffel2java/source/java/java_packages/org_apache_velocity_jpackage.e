note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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
	
end -- class ORG_APACHE_VELOCITY_JPACKAGE
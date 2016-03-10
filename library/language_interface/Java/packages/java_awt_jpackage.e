note
	description: "Summary description for {JAVA_AWT_JPACKAGE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2011-07-24 9:48:03 GMT (Sunday 24th July 2011)"
	revision: "1"

deferred class
	JAVA_AWT_JPACKAGE

inherit
	JAVA_PACKAGE

feature -- Constant

	Package_name: STRING
			--
		once
			Result := "java.awt"
		end

end

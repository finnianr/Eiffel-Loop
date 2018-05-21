note
	description: "Java lang jpackage"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	JAVA_LANG_JPACKAGE

inherit
	JAVA_PACKAGE

feature -- Constant
	Package_name: STRING 
			--
		once
			Result := "java.lang"
		end
	
end -- class JAVA_LANG_JPACKAGE
note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

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

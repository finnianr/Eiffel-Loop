note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	JAVA_IO_JPACKAGE

inherit
	JAVA_PACKAGE

feature -- Constant

	Package_name: STRING 
			--
		once
			Result := "java.io"
		end

end -- class JAVA_IO_JPACKAGE
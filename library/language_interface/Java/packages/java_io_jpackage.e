note
	description: "Java package: `java.io'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 10:54:46 GMT (Wednesday 10th March 2021)"
	revision: "5"

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
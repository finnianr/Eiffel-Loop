note
	description: "Java package: `java.lang'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

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

end
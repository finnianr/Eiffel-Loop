note
	description: "Interface to Java class: `java.util.HashMap'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	J_HASH_MAP

inherit
	JAVA_UTIL_JPACKAGE

	J_OBJECT
		undefine
			Package_name
		end

create
	make

feature -- Element change

	put_string (key, value: J_STRING): J_OBJECT
			--
		do
			Result := put (key, value)
		end

	put (key, value: J_OBJECT): J_OBJECT
			--
		do
			Result := Jagent_put.item (Current, [key, value])
		end

feature {NONE} -- Constants

	Jagent_put: JAVA_FUNCTION [J_OBJECT]
			--
		once
			create Result.make ("put", agent put)
		end

end
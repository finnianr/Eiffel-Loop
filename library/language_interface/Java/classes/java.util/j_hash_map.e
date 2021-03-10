note
	description: "Interface to Java class: `java.util.HashMap'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-10 15:47:34 GMT (Wednesday 10th March 2021)"
	revision: "4"

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
			Result := jagent_put.item (Current, [key, value])
		end

feature {NONE} -- Implementation

	jagent_put: JAVA_FUNCTION [J_OBJECT]
			--
		once
			create Result.make ("put", agent put)
		end

end
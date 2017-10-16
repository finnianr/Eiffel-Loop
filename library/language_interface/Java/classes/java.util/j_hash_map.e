note
	description: "Eiffel wrapper for class java.util.HashMap"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	J_HASH_MAP

inherit
	JAVA_UTIL_JPACKAGE

	J_OBJECT
		undefine
			Jclass, Package_name
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

	jagent_put: JAVA_FUNCTION [J_HASH_MAP, J_OBJECT]
			--
		once
			create Result.make ("put", agent put)
		end

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "HashMap")
		end

end
note
	description: "Interface to Java class: `java.lang.Object'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-11 10:47:16 GMT (Thursday 11th March 2021)"
	revision: "6"

class
	J_OBJECT

inherit
	JAVA_LANG_JPACKAGE

	JAVA_OBJECT_REFERENCE

create
	default_create,
	make,
	make_from_pointer,
	make_from_java_method_result,
	make_from_java_attribute

feature -- Access

	to_string: J_STRING
			--
		do
			Result := Jagent_to_string.item (Current, [])
		end

feature -- Status query

	equals (other: J_OBJECT): J_BOOLEAN
		do
			Result := Jagent_equals.item (Current, [other])
		end

feature {NONE} -- Constants

	Jagent_to_string: JAVA_FUNCTION [J_STRING]
			--
		once
			create Result.make ("toString", agent to_string)
		end

	Jagent_equals: JAVA_FUNCTION [J_BOOLEAN]
			--
		once
			create Result.make ("equals", agent equals)
		end

end
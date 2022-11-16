note
	description: "Interface to Java class: `java.lang.Object'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

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
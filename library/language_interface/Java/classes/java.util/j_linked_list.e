note
	description: "Interface to Java class: `java.util.LinkedList'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-11 10:48:39 GMT (Thursday 11th March 2021)"
	revision: "6"

class
	J_LINKED_LIST

inherit
	J_OBJECT
		undefine
			Package_name
		end

	JAVA_UTIL_JPACKAGE

create
	make, default_create, make_from_java_method_result

feature -- Element change

	remove_first: J_OBJECT
			--
		do
			Result := Jagent_remove_first.item (Current, [])
		end

	add_last_string (string: ZSTRING)
			--
		do
			add_last (create {J_STRING}.make_from_string (string))
		end

	add_last (obj: J_OBJECT)
			--
		do
			Jagent_add_last.call (Current, [obj])
		end

feature -- Status query

	is_empty: J_BOOLEAN
			--
		do
			Result := Jagent_is_empty.item (Current, [])
		end

feature {NONE} -- Constants

	Jagent_remove_first: JAVA_FUNCTION [J_OBJECT]
			--
		once
			create Result.make ("removeFirst", agent remove_first)
		end

	Jagent_add_last: JAVA_PROCEDURE
			--
		once
			create Result.make ("addLast", agent add_last)
		end

	Jagent_is_empty: JAVA_FUNCTION [J_BOOLEAN]
			--
		once
			create Result.make ("isEmpty", agent is_empty)
		end

end
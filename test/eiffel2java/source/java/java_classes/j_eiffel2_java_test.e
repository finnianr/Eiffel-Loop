note
	description: "Interface to Java class: `Eiffel2JavaTest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 20:26:10 GMT (Monday 13th January 2020)"
	revision: "6"

class
	J_EIFFEL2_JAVA_TEST

inherit
	J_OBJECT
		undefine
			Package_name
		end

	DEFAULT_JPACKAGE

create
	make, make_from_pointer,
	make_from_string, make_from_java_method_result, make_from_java_attribute

feature -- Access

	my_function (n: J_INT; s: J_STRING): J_FLOAT
			--
		do
			Result := Jagent_my_function.item (Current, [n, s])
		end

	my_integer: J_INT
			--
		do
			Result := Jagent_my_integer.item (Current)
		end

	my_method (n: J_INT; s: J_STRING)
			--
		do
			Jagent_my_method.call (Current, [n, s])
		end

	my_static_integer: J_INT
			--
		do
			Result := Jagent_my_static_integer.item (Current)
		end

	my_string: J_STRING
			--
		do
			Result := Jagent_my_string.item (Current)
		end

	name: J_STRING
			--
		do
			Result := Jagent_name.item (Current)
		end

	string_list (array: J_OBJECT_ARRAY [J_STRING]): J_LINKED_LIST
			--
		do
			Result := Jagent_string_list.item (Current, [array])
		end

feature {NONE} -- Initialization

	make_from_string (s: J_STRING)
			--
		do
			make_from_pointer (Jagent_make_from_string.java_object_id (Current, [s]))
		end

feature {NONE} -- Constants

	Jagent_make_from_string: JAVA_CONSTRUCTOR
			--
		once
			create Result.make (agent make_from_string)
		end

	Jagent_my_function: JAVA_FUNCTION [J_FLOAT]
			--
		once
			create Result.make ("my_function", agent my_function)
		end

	Jagent_my_integer: JAVA_ATTRIBUTE [J_INT]
			--
		once
			create Result.make ("my_integer", agent my_integer)
		end

	Jagent_my_method: JAVA_PROCEDURE
			--
		once
			create Result.make ("my_method", agent my_method)
		end

	Jagent_my_static_integer: JAVA_STATIC_ATTRIBUTE [J_INT]
			--
		once
			create Result.make ("my_static_integer", agent my_static_integer)
		end

	Jagent_my_string: JAVA_ATTRIBUTE [J_STRING]
			--
		once
			create Result.make ("my_string", agent my_string)
		end

	Jagent_name: JAVA_ATTRIBUTE [J_STRING]
			--
		once
			create Result.make ("name", agent name)
		end

	Jagent_string_list: JAVA_FUNCTION [J_LINKED_LIST]
			--
		once
			create Result.make ("stringList", agent string_list)
		end

end

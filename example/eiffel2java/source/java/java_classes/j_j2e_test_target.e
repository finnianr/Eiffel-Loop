note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	J_J2E_TEST_TARGET

inherit
	DEFAULT_JPACKAGE

	JAVA_OBJECT_REFERENCE

create
	make_from_string,
	make,
	make_from_pointer,
	make_from_java_method_result,
	make_from_java_attribute

feature -- Access

	string_list: J_LINKED_LIST
			--
		do
			log.enter ("string_list")
			Result := jagent_string_list.item (Current, [])
			log.exit

		end

	my_integer: J_INT
			--
		do
			log.enter ("my_integer")
			Result := jagent_my_integer.item (Current)
			log.put_integer_field ("Result", Result.value)
			log.put_new_line
			log.exit
		end

	my_string: J_STRING
			--
		do
			log.enter ("my_string")
			Result := jagent_my_string.item (Current)
			log.put_string_field ("Result", Result.value)
			log.put_new_line
			log.exit
		end

	name: J_STRING
			--
		do
			log.enter ("name")
			Result := jagent_name.item (Current)
			log.put_string_field ("Result", Result.value)
			log.put_new_line
			log.exit
		end

	my_static_integer: J_INT
			--
		do
			log.enter ("my_static_integer")
			Result := jagent_my_static_integer.item (Current)
			log.put_integer_field ("Result", Result.value)
			log.put_new_line
			log.exit
		end

	my_function (n: J_INT; s: J_STRING): J_FLOAT
			--
		do
			log.enter_with_args ("my_function", << n.value, s.value >>)
			Result := jagent_my_function.item (Current, [n, s])
			log.put_string_field ("Result", Result.value.out)
			log.put_new_line
			log.exit
		end

	my_method (n: J_INT; s: J_STRING)
			--
		do
			log.enter_with_args ("my_method", << n.value, s.value >>)
			jagent_my_method.call (Current, [n, s])
			log.exit
		end

feature {NONE} -- Initialization

	make_from_string (s: J_STRING)
			--
		do
			make_from_pointer (jagent_make_from_string.java_object_id (Current, [s]))
		end

feature {NONE} -- Implementation

	jagent_string_list: JAVA_FUNCTION [J_J2E_TEST_TARGET, J_LINKED_LIST]
			--
		once
			create Result.make ("stringList", agent string_list)
		end

	jagent_my_function: JAVA_FUNCTION [J_J2E_TEST_TARGET, J_FLOAT]
			--
		once
			create Result.make ("my_function", agent my_function)
		end

	jagent_my_static_integer: JAVA_STATIC_ATTRIBUTE [J_J2E_TEST_TARGET, J_INT]
			--
		once
			create Result.make ("my_static_integer", agent my_static_integer)
		end

	jagent_my_integer: JAVA_ATTRIBUTE [J_J2E_TEST_TARGET, J_INT]
			--
		once
			create Result.make ("my_integer", agent my_integer)
		end

	jagent_my_string: JAVA_ATTRIBUTE [J_J2E_TEST_TARGET, J_STRING]
			--
		once
			create Result.make ("my_string", agent my_string)
		end

	jagent_name: JAVA_ATTRIBUTE [J_J2E_TEST_TARGET, J_STRING]
			--
		once
			create Result.make ("name", agent name)
		end

	jagent_my_method: JAVA_PROCEDURE [J_J2E_TEST_TARGET]
			--
		once
			create Result.make ("my_method", agent my_method)
		end

	jagent_make_from_string: JAVA_CONSTRUCTOR [J_J2E_TEST_TARGET ]
			--
		once
			create Result.make (agent make_from_string)
		end

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "J2ETestTarget")
		end

end -- class JAVA_CLASS

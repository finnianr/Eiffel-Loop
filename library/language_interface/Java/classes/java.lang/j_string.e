note
	description: "J string"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-09 17:14:05 GMT (Tuesday 9th March 2021)"
	revision: "6"

class
	J_STRING

inherit
	JAVA_LANG_JPACKAGE

	J_OBJECT
		redefine
			Jclass
		end

	JAVA_TO_EIFFEL_CONVERTABLE [ZSTRING]
		undefine
			is_equal
		end

create
	make, make_from_other,
	make_from_utf_8,
	make_from_string,
	make_from_java_method_result,
	make_from_java_attribute,
	make_from_java_object,
	make_from_pointer

convert
	make_from_utf_8 ({STRING}), make_from_string ({ZSTRING})

feature {NONE} -- Initialization

	make_from_other (other: J_STRING)
		do
			make_from_pointer (Jagent_make_from_other.java_object_id (Current, [other]))
		end

	make_from_string (str: ZSTRING)
			--
		do
			make_from_utf_8 (str.to_utf_8 (False))
		end

	make_from_utf_8 (utf_8: STRING)
			--
		do
			make_from_pointer (jni.new_string (utf_8) )
		end

feature -- Access

	value: ZSTRING
			--
		do
			if is_attached (java_object_id) then
				create Result.make_from_utf_8 (jni.get_string (java_object_id))
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Constant

	Jagent_make_from_other: JAVA_CONSTRUCTOR [J_STRING]
			--
		once
			create Result.make (agent make_from_other)
		end

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "String")
		end

end
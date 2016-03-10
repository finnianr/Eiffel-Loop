note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-18 10:21:15 GMT (Tuesday 18th December 2012)"
	revision: "1"

class
	J_STRING

inherit
	JAVA_LANG_JPACKAGE

	J_OBJECT
		redefine
			Jclass
		end

	JAVA_TO_EIFFEL_CONVERTABLE [STRING]
		undefine
			is_equal
		end

create
	default_create,
	make,
	make_from_string,
	make_from_java_method_result,
	make_from_java_attribute,
	make_from_java_object,
	make_from_pointer

convert
	make_from_string ({STRING})

feature {NONE} -- Initialization

	make_from_string (s: STRING)
			--
		do
			make_from_pointer (jni.new_string (s) )
		end

feature -- Access

	value: STRING
			--
		do
			if is_attached (java_object_id) then
				Result := jni.get_string (java_object_id)
			end
		end

feature {NONE} -- Constant

	Jclass: JAVA_CLASS_REFERENCE
			--
		once
			create Result.make (Package_name, "String")
		end

end -- class J_STRING

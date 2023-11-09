note
	description: "Java class: `java.lang.String'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-09 11:46:37 GMT (Thursday 9th November 2023)"
	revision: "11"

class
	J_STRING

inherit
	J_OBJECT

	JAVA_TO_EIFFEL_CONVERTABLE [ZSTRING]
		undefine
			is_equal
		end

	JAVA_LANG_JPACKAGE

	EL_SHARED_STRING_8_CURSOR; EL_SHARED_STRING_8_BUFFER_SCOPES

create
	default_create,
	make,
	make_from_utf_8,
	make_from_string,
	make_from_string_8,
	make_from_java_method_result,
	make_from_java_attribute,
	make_from_java_object,
	make_from_pointer

convert
	make_from_string_8 ({STRING}), make_from_string ({ZSTRING})

feature {NONE} -- Initialization

	make_from_string (str: ZSTRING)
			--
		do
			across String_8_scope as scope loop
				make_from_utf_8 (scope.copied_utf_8_item (str))
			end
		end

	make_from_string_8 (str: STRING)
		--
		local
			conv: EL_UTF_CONVERTER
		do
			if cursor_8 (str).all_ascii then
				make_from_pointer (jni.new_string (str))
			else
				across String_8_scope as scope loop
					conv.utf_32_string_into_utf_8_string_8 (str, scope.item)
					make_from_pointer (jni.new_string (scope.item))
				end
			end
		end

	make_from_utf_8 (utf_8: STRING)
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

end
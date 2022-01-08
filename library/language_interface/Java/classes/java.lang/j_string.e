note
	description: "Java class: `java.lang.String'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-08 16:26:10 GMT (Saturday 8th January 2022)"
	revision: "6"

class
	J_STRING

inherit
	J_OBJECT

	JAVA_TO_EIFFEL_CONVERTABLE [ZSTRING]
		undefine
			is_equal
		end

	JAVA_LANG_JPACKAGE

	EL_MODULE_REUSABLE

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
			make_from_utf_8 (str.to_utf_8 (False))
		end

	make_from_string_8 (str: STRING)
		--
		local
			s: EL_STRING_8_ROUTINES; conv: EL_UTF_CONVERTER
		do
			if s.is_ascii (str) then
				make_from_pointer (jni.new_string (str))
			else
				across Reuseable.string_8 as reuse loop
					conv.utf_32_string_into_utf_8_string_8 (str, reuse.item)
					make_from_pointer (jni.new_string (reuse.item))
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
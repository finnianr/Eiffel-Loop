note
	description: "Java class: `java.lang.String'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 14:32:30 GMT (Monday 21st April 2025)"
	revision: "13"

class
	J_STRING

inherit
	J_OBJECT

	JAVA_TO_EIFFEL_CONVERTABLE [ZSTRING]
		undefine
			is_equal
		end

	JAVA_LANG_JPACKAGE

	EL_SHARED_STRING_8_BUFFER_POOL

create
	default_create, make,
	make_from_string, make_from_string_8, make_from_utf_8,
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
			if attached String_8_pool.borrowed_item as borrowed then
				make_from_utf_8 (borrowed.copied_general_as_utf_8 (str))
				borrowed.return
			end
		end

	make_from_string_8 (str: STRING)
		--
		local
			conv: EL_UTF_CONVERTER
		do
			if cursor_8 (str).all_ascii then
				make_from_pointer (jni.new_string (str))

			elseif attached String_8_pool.borrowed_item as borrowed then
				if attached borrowed.empty as utf_8 then
					conv.utf_32_string_into_utf_8_string_8 (str, utf_8)
					make_from_pointer (jni.new_string (utf_8))
				end
				borrowed.return
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
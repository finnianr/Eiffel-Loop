note
	description: "[
		Reflected field can be associated with a string representation type `G', for example an
		[$source INTEGER_32] field can be associated with a [$source DATE] type.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
	EL_STRING_REPRESENTABLE_FIELD [G]

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			if attached {EL_STRING_REPRESENTATION [G, ANY]} representation as l_representation then
				Result := l_representation.to_string (value (a_object))
			else
				Result := to_string_directly (a_object)
			end
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached {EL_STRING_REPRESENTATION [G, ANY]} representation as l_representation then
				l_representation.append_to_string (value (a_object), str)
			else
				append_directly (a_object, str)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		-- forced to implement in descendants because of a segmentation fault in finalized exe
		deferred
		end

feature {NONE} -- Implementation

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		deferred
		end

	representation: detachable EL_FIELD_REPRESENTATION [G, ANY]
		deferred
		end

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		deferred
		end

	to_string_directly (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		deferred
		end

	value (a_object: EL_REFLECTIVE): G
		deferred
		end

end
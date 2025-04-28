note
	description: "[
		Reflected field can be associated with a string representation type `G', for example an
		${INTEGER_32} field can be associated with a ${DATE} type.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:18:08 GMT (Monday 28th April 2025)"
	revision: "7"

deferred class
	EL_STRING_REPRESENTABLE_FIELD [G]

feature -- Access

	to_string (object: ANY): READABLE_STRING_GENERAL
		do
			if attached {EL_STRING_FIELD_REPRESENTATION [G, ANY]} representation as l_representation then
				Result := l_representation.to_string (value (object))
			else
				Result := to_string_directly (object)
			end
		end

feature -- Basic operations

	append_to_string (object: ANY; str: ZSTRING)
		do
			if attached {EL_STRING_FIELD_REPRESENTATION [G, ANY]} representation as l_representation then
				l_representation.append_to_string (value (object), str)
			else
				append_directly (object, str)
			end
		end

	set_from_string (object: ANY; string: READABLE_STRING_GENERAL)
		-- forced to implement in descendants because of a segmentation fault in finalized exe
		deferred
		end

feature {NONE} -- Implementation

	append_directly (object: ANY; str: ZSTRING)
		deferred
		end

	representation: detachable EL_FIELD_REPRESENTATION [G, ANY]
		deferred
		end

	set_directly (object: ANY; string: READABLE_STRING_GENERAL)
		deferred
		end

	to_string_directly (object: ANY): READABLE_STRING_GENERAL
		deferred
		end

	value (object: ANY): G
		deferred
		end

end
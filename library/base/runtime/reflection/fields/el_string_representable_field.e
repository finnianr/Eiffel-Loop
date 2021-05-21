note
	description: "[
		Reflected field can be associated with a string representation type `G', for example an
		[$source INTEGER_32] field can be associated with a [$source DATE] type.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-21 18:43:58 GMT (Friday 21st May 2021)"
	revision: "1"

deferred class
	EL_STRING_REPRESENTABLE_FIELD [G]

feature -- Access

	representation: EL_STRING_REPRESENTATION [G, ANY]
		-- object allowing text representation and conversion of field

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			if attached representation as l_representation then
				Result := l_representation.to_string (value (a_object))
			else
				Result := to_string_directly (a_object)
			end
		end

feature -- Status query

	has_representation: BOOLEAN
		-- `True' if associated with text representation object
		do
			Result := attached representation
		end

feature -- Element change

	set_representation (a_representation: like representation)
		require
			correct_type: a_representation.value_type ~ {G}
		do
			representation := a_representation
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached representation as l_representation then
				l_representation.append_to_string (value (a_object), str)
			else
				append_directly (a_object, str)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		-- forced to implement in descendants because of a segmentation fault in finalized exe
		deferred
		end

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			if attached representation as l_representation then
				l_representation.write_crc (crc)
			end
		end

feature {NONE} -- Implementation

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
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
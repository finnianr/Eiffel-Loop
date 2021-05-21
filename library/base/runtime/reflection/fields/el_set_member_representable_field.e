note
	description: "Reflected field that can be associated with a set of type [$source EL_HASH_SET [G]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-21 19:02:11 GMT (Friday 21st May 2021)"
	revision: "1"

deferred class
	EL_SET_MEMBER_REPRESENTABLE_FIELD [G -> HASHABLE]

inherit
	EL_STRING_REPRESENTABLE_FIELD [G]
		undefine
			append_to_string, to_string
		redefine
			representation
		end

feature -- Access

	representation: EL_HASH_SET_REPRESENTATION [G]
		-- object allowing text representation and conversion of field

feature -- Basic operations

	read_from_set (a_object: EL_REFLECTIVE; reader: EL_CACHED_FIELD_READER; a_set: EL_HASH_SET [G])
		deferred
		end

feature {NONE} -- Implementation

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
		end

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
		end

	to_string_directly (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
		end

end
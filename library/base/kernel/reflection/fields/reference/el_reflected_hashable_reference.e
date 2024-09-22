note
	description: "[
		Reflected reference field conforming to ${HASHABLE} with the possibility to
		eliminate duplicate values by looking up values in a ${EL_HASH_SET} object.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 11:30:09 GMT (Sunday 22nd September 2024)"
	revision: "34"

class
	EL_REFLECTED_HASHABLE_REFERENCE [H -> HASHABLE]

inherit
	EL_REFLECTED_REFERENCE [H]
		redefine
			set, set_initial, set_representation
		end

create
	make

feature -- Status query

	is_value_cached: BOOLEAN

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: H)
		do
			if is_value_cached and then attached hash_set as l_set then
				l_set.put_copy (a_value)
				Precursor (a_object, l_set.found_item)
			else
				Precursor (a_object, a_value)
			end
		end

	set_initial (a_object: EL_REFLECTIVE; a_value: H)
		do
			Precursor (a_object, a_value)
		end

feature -- Element change

	set_representation (a_representation: like representation)
		do
			Precursor (a_representation)
			if attached {EL_HASH_SET_REPRESENTATION [HASHABLE]} a_representation as hashable
				and then attached {EL_HASH_SET [H]} hashable.hash_set as l_hash_set
			then
				hash_set := l_hash_set
			end
			is_value_cached := True
		end

feature {NONE} -- Internal attributes

	hash_set: detachable EL_HASH_SET [H];

note
	descendants: "[
			EL_REFLECTED_HASHABLE_REFERENCE [H -> HASHABLE]
				${EL_REFLECTED_STRING* [S -> READABLE_STRING_GENERAL create make end]}
					${EL_REFLECTED_STRING_8}
					${EL_REFLECTED_IMMUTABLE_STRING_8}
					${EL_REFLECTED_IMMUTABLE_STRING_32}
					${EL_REFLECTED_STRING_32}
					${EL_REFLECTED_URI [U -> EL_URI create make end]}
					${EL_REFLECTED_ZSTRING}
				${EL_REFLECTED_PATH}
	]"

end
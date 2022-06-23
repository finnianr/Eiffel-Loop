note
	description: "[
		Reflected field that conforms to [$source STRING_GENERAL] and is a member of an
		associated set.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-23 8:54:13 GMT (Thursday 23rd June 2022)"
	revision: "7"

deferred class
	EL_REFLECTED_MEMBER_STRING [S -> STRING_GENERAL create make end]

inherit
	EL_REFLECTED_STRING [S]
		rename
			make as make_field
		redefine
			set, set_from_string_general
		end

feature {NONE} -- Initialization

	make (reflected: EL_REFLECTED_STRING [S])
		require
			has_hash_set: attached {EL_HASH_SET_REPRESENTATION [S]} reflected.representation
		do
			make_field (reflected.enclosing_object, reflected.index, reflected.name)
			if attached {EL_HASH_SET_REPRESENTATION [S]} reflected.representation as l_representation then
				hash_set := l_representation.hash_set
			end
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: S)
		do
			if not hash_set.has_key (a_value) then
				hash_set.put (a_value.twin)
			end
			Precursor (a_object, hash_set.found_item)
		ensure then
			member_of_set: hash_set.has (value (a_object))
		end

	set_from_node (a_object: EL_REFLECTIVE; node: EL_STRING_NODE)
		deferred
		end

	set_from_string_general (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			set (a_object, buffer.to_same (string))
		end

feature -- Access

	hash_set: EL_HASH_SET [S]

feature {NONE} -- Implementation

	buffer: EL_STRING_BUFFER [S, READABLE_STRING_GENERAL]
		deferred
		end

end
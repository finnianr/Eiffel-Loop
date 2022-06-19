note
	description: "[
		Reflected field that conforms to [$source STRING_GENERAL] and is a member of an
		associated set.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-19 10:24:23 GMT (Sunday 19th June 2022)"
	revision: "6"

deferred class
	EL_REFLECTED_MEMBER_STRING [S -> STRING_GENERAL create make end]

inherit
	EL_REFLECTED_STRING [S]
		rename
			make as make_field
		redefine
			set, set_from_string_general
		end

	EL_MODULE_REUSEABLE

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
			if attached {S} string as str then
				set (a_object, str)

			else
				across reuseable_string as reuse loop
					reuse.item.append (string)
					set (a_object, reuse.item)
				end
			end
		end

feature -- Access

	hash_set: EL_HASH_SET [S]

feature {NONE} -- Implementation

	reuseable_string: EL_BORROWED_STRING_SCOPE [S]
		deferred
		end

end
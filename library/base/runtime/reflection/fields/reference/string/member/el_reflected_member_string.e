note
	description: "[
		Reflected field that conforms to [$source STRING_GENERAL] and is a member of an
		associated set.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-12 13:22:47 GMT (Thursday 12th August 2021)"
	revision: "2"

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
			if hash_set.has_key (a_value) then
				Precursor (a_object, hash_set.found_item)
			else
				hash_set.put (a_value.twin)
				Precursor (a_object, hash_set.found_item)
			end
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

			elseif attached pool.new_scope as p and then attached p.reuse_item as buffer then
				buffer.append (string)
				set (a_object, buffer)
				p.recycle_end (buffer)
			end
		end

feature -- Access

	hash_set: EL_HASH_SET [S]

feature {NONE} -- Internal attributes

	pool: EL_STRING_POOL [S]
		deferred
		end

end
note
	description: "[
		Reflected field of type [$source STRING_8] with values that are members
		of an associated set of type [$source EL_HASH_SET [STRING_8]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-23 11:10:40 GMT (Sunday 23rd May 2021)"
	revision: "1"

class
	EL_REFLECTED_MEMBER_STRING_8

inherit
	EL_REFLECTED_MEMBER_STRING [STRING_8]
		rename
			pool as String_8_pool
		end

	EL_REFLECTED_STRING_8
		rename
			make as make_field
		undefine
			set, set_from_string_general
		end

	EL_STRING_8_CONSTANTS

create
	make

feature -- Basic operations

	set_from_node (a_object: EL_REFLECTIVE; node: EL_STRING_NODE)
		do
			set (a_object, node.as_string_8 (False))
		end

end
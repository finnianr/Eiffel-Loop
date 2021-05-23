note
	description: "[
		Reflected field of type [$source EL_ZSTRING] with values that are members
		of an associated set of type [$source EL_HASH_SET [ZSTRING]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-23 11:14:34 GMT (Sunday 23rd May 2021)"
	revision: "1"

class
	EL_REFLECTED_MEMBER_ZSTRING

inherit
	EL_REFLECTED_MEMBER_STRING [ZSTRING]
		rename
			pool as string_pool
		undefine
			append_to_string
		end

	EL_REFLECTED_ZSTRING
		rename
			make as make_field
		undefine
			set, set_from_string_general
		end

	EL_ZSTRING_CONSTANTS

create
	make

feature -- Basic operations

	set_from_node (a_object: EL_REFLECTIVE; node: EL_STRING_NODE)
		do
			set (a_object, node.as_string (False))
		end

end
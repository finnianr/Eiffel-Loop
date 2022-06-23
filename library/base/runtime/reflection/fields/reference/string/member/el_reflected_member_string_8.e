note
	description: "[
		Reflected field of type [$source STRING_8] with values that are members
		of an associated set of type [$source EL_HASH_SET [STRING_8]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-23 8:54:39 GMT (Thursday 23rd June 2022)"
	revision: "4"

class
	EL_REFLECTED_MEMBER_STRING_8

inherit
	EL_REFLECTED_MEMBER_STRING [STRING_8]
		rename
			buffer as Buffer_8
		end

	EL_REFLECTED_STRING_8
		rename
			make as make_field
		undefine
			set, set_from_string_general
		end

create
	make

feature -- Basic operations

	set_from_node (a_object: EL_REFLECTIVE; node: EL_STRING_NODE)
		do
			set (a_object, node.as_string_8 (False))
		end

end
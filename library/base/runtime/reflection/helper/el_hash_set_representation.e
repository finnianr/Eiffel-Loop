note
	description: "Reflected field representation that "

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-21 19:12:36 GMT (Friday 21st May 2021)"
	revision: "1"

class
	EL_HASH_SET_REPRESENTATION [G -> HASHABLE]

inherit
	EL_STRING_REPRESENTATION [G, G]

create
	make

feature {NONE} -- Initialization

	make (a_hash_set: like hash_set)
		do
			hash_set := a_hash_set
		end

feature -- Access

	to_string (a_value: like to_value): READABLE_STRING_GENERAL
		require else
			never_called: False
		do
		end

	hash_set: EL_HASH_SET [G]

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- " + value_type.name + " in assigned " + hash_set.generator)
		end

	to_value (str: READABLE_STRING_GENERAL): G
		require else
			never_called: False
		do
		end

end
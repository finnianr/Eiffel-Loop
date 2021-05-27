note
	description: "Reflected field representation that "

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-24 12:24:18 GMT (Monday 24th May 2021)"
	revision: "2"

class
	EL_HASH_SET_REPRESENTATION [G -> HASHABLE]

inherit
	EL_FIELD_REPRESENTATION [G, EL_HASH_SET [G]]
		rename
			item as hash_set
		end

create
	make

feature {NONE} -- Initialization

	make (a_hash_set: like hash_set)
		do
			hash_set := a_hash_set
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- " + value_type.name + " in assigned " + hash_set.generator)
		end

end
note
	description: "Reflected field representation that links a field to a set of values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-19 10:18:09 GMT (Sunday 19th June 2022)"
	revision: "4"

class
	EL_HASH_SET_REPRESENTATION [G -> HASHABLE]

inherit
	EL_FIELD_REPRESENTATION [G, EL_HASH_SET [G]]
		rename
			item as hash_set
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_hash_set: like hash_set)
		do
			hash_set := a_hash_set
		end

	make_default
		do
			create hash_set.make (11)
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- " + value_type.name + " in assigned " + hash_set.generator)
		end

end
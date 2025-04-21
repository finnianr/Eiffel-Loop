note
	description: "[
		Wrap any object conforming to ${READABLE_INDEXABLE} to use routines from ${EL_INDEXABLE_FROM_1}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-20 9:26:46 GMT (Sunday 20th April 2025)"
	revision: "1"

class
	EL_INDEXABLE_FROM_1_WRAPPER

inherit
	EL_INDEXABLE_FROM_1

	ANY
		redefine
			default_create
		end

	EL_STRING_8_CONSTANTS

feature {NONE} -- Initialization

	default_create
		do
			indexable := Empty_string_8
		end

feature -- Measurement

	count: INTEGER
		do
			Result := indexable.upper - indexable.lower + 1
		end

feature -- Element change

	set_indexable (a_indexable: like indexable)
		do
			indexable := a_indexable
		end

feature -- Status query

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' a valid index?
		do
			Result := indexable.valid_index (i)
		end

feature {NONE} -- Internal attributes

	indexable: READABLE_INDEXABLE [ANY]
end
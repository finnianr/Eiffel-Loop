note
	description: "Sortable list of strings conforming to READABLE_STRING_GENERAL"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-20 9:40:04 GMT (Wednesday 20th December 2023)"
	revision: "2"

deferred class
	EL_SORTABLE_STRING_LIST [S -> READABLE_STRING_GENERAL]

inherit
	READABLE_INDEXABLE [S]

feature -- Measurement

	count: INTEGER
		deferred
		end

	item_index_of (uc: CHARACTER_32): INTEGER
		require
			valid_item: not off
		deferred
		end

feature -- Status query

	off: BOOLEAN
		deferred
		end

feature -- Basic operations

	go_i_th (i: INTEGER)
			-- Move cursor to `i'-th position.
		deferred
		end

	sort (in_ascending_order: BOOLEAN)
		deferred
		end
end
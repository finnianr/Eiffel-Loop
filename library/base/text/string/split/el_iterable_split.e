note
	description: "Iterable string split with separator of type **SEPAR**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 22:28:11 GMT (Wednesday 16th April 2025)"
	revision: "16"

deferred class
	EL_ITERABLE_SPLIT [RSTRING -> READABLE_STRING_GENERAL, CHAR -> COMPARABLE, SEPARATOR]

inherit
	ITERABLE [RSTRING]

	EL_ITERABLE_SPLIT_BASE [RSTRING, SEPARATOR]

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Measurement

	count: INTEGER
		deferred
		end

feature -- Access

	new_cursor: EL_ITERABLE_SPLIT_CURSOR [RSTRING, CHAR, SEPARATOR]
			-- Fresh cursor associated with current structure
		deferred
		end

feature -- Status query

	has_item (str: RSTRING): BOOLEAN
		do
			Result := across Current as list some list.item_same_as (str) end
		end

end
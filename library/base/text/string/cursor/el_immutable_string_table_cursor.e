note
	description: "Iteration cursor for [$source EL_IMMUTABLE_STRING_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-11 16:35:46 GMT (Friday 11th August 2023)"
	revision: "3"

class
	EL_IMMUTABLE_STRING_TABLE_CURSOR [IMMUTABLE -> IMMUTABLE_STRING_GENERAL]

inherit
	HASH_TABLE_ITERATION_CURSOR [INTEGER_64, IMMUTABLE]
		rename
			item as interval_item
		export
			{NONE} interval_item
		redefine
			target
		end

create
	make

feature -- Access

	item: IMMUTABLE
		do
			Result := target.new_item_substring (interval_item)
		end

feature {NONE} -- Internal attributes

	target: EL_IMMUTABLE_STRING_TABLE [STRING_GENERAL, IMMUTABLE]
end
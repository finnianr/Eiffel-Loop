note
	description: "Iteration cursor for ${EL_IMMUTABLE_STRING_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 14:31:21 GMT (Sunday 22nd September 2024)"
	revision: "5"

class
	EL_IMMUTABLE_STRING_TABLE_CURSOR [IMMUTABLE -> IMMUTABLE_STRING_GENERAL]

inherit
	EL_HASH_TABLE_ITERATION_CURSOR [INTEGER_64, IMMUTABLE]
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
note
	description: "Iteration cursor for ${EL_IMMUTABLE_UTF_8_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_IMMUTABLE_UTF_8_TABLE_CURSOR

inherit
	EL_IMMUTABLE_STRING_TABLE_CURSOR [IMMUTABLE_STRING_8]
		rename
			item as utf_8_item
		redefine
			target
		end

create
	make

feature -- Access

	item: ZSTRING
		do
			Result := target.new_item (interval_item)
		end

feature {NONE} -- Internal attributes

	target: EL_IMMUTABLE_UTF_8_TABLE
end
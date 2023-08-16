note
	description: "Iteration cursor for [$source EL_IMMUTABLE_UTF_8_TABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-12 7:16:36 GMT (Saturday 12th August 2023)"
	revision: "2"

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
note
	description: "Cache for font sets with default monospace style"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_FONT_SET_CACHE

inherit
	HASH_TABLE [EL_FONT_SET, EL_FONT_KEY]
		export
			{NONE} all
		redefine
			make_equal
		end

	EL_MODULE_ACTION

	EL_MODULE_SCREEN

create
	make_equal

feature {NONE} -- Initialization

	make_equal (n: INTEGER)
			-- Allocate hash table for at least `n' items.
			-- The table will be resized automatically
			-- if more than `n' items are inserted.
			-- Use `~' to compare items.
		do
			Precursor (n)
			create font_key
		end

feature -- Access

	font_set (font: EV_FONT): EL_FONT_SET
		do
			font_key.set (font)
			if has_key (font_key) then
				Result := found_item
			else
				Result := new_font_set (font)
				extend (Result, font_key.twin)
			end
		end

feature {NONE} -- Implementation

	new_font_set (font: EV_FONT): EL_FONT_SET
		do
			create Result.make_monospace_default (font)
		end

feature {NONE} -- Internal attributes

	font_key: EL_FONT_KEY

end
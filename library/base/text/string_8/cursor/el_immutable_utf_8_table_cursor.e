note
	description: "Iteration cursor for ${EL_IMMUTABLE_UTF_8_TABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 18:35:56 GMT (Saturday 5th April 2025)"
	revision: "6"

class
	EL_IMMUTABLE_UTF_8_TABLE_CURSOR

inherit
	EL_IMMUTABLE_STRING_TABLE_CURSOR [IMMUTABLE_STRING_8]
		rename
			item as utf_8_item
		redefine
			target
		end

	EL_MODULE_UTF_8

	EL_STRING_GENERAL_ROUTINES_I

create
	make

feature -- Access

	item: ZSTRING
		do
			Result := target.new_item (interval_item)
		end

	item_32: STRING_32
		do
			if attached utf_8_item as str_8 then
				if super_readable_8 (str_8).is_ascii then
					Result := str_8.to_string_32
				else
					create Result.make (Utf_8.unicode_count (str_8))
					Utf_8.string_8_into_string_general (str_8, Result)
				end
			end
		end

	item_8, item_latin_1: STRING_8
		do
			if attached utf_8_item as str_8 then
				if super_readable_8 (str_8).is_ascii then
					Result := str_8
				else
					create Result.make (Utf_8.unicode_count (str_8))
					Utf_8.string_8_into_string_general (str_8, Result)
				end
			end
		end

feature {NONE} -- Internal attributes

	target: EL_IMMUTABLE_UTF_8_TABLE
end
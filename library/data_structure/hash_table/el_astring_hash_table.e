note
	description: "Summary description for {EL_STRING_HASH_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:07:59 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_ASTRING_HASH_TABLE [G]

inherit
	EL_HASH_TABLE [G, EL_ASTRING]
		rename
			make as make_table, append_tuples as append_tuples_table
		export
			{NONE} append_tuples_table
		end

create
	default_create, make, make_equal, make_with_count

feature {NONE} -- Initialization

	make (array: like Type_general_keys)
			--
		do
			make_table (augmented_latin_keys (array))
		end

feature -- Element change

	append_tuples (array: like Type_general_keys)
		do
			append_tuples_table (augmented_latin_keys (array))
		end

feature {NONE} -- Implementation

	augmented_latin_keys (array: like Type_general_keys): ARRAY [TUPLE [EL_ASTRING, G]]
			-- Convert to keys to type EL_ASTRING
		local
			i: INTEGER
			key: EL_ASTRING
			tuple_item: like Type_general_keys.item
		do
			create Result.make (1, array.count)
			from i := 1 until i > array.count loop
				tuple_item := array [i]
				if attached {EL_ASTRING} tuple_item.key as astring_key then
					key := astring_key
				else
					create key.make_from_unicode (tuple_item.key)
				end
				Result [i] := [key, tuple_item.value]
				i := i + 1
			end
		end

feature {NONE} -- Type definitions

	Type_general_keys: ARRAY [TUPLE [key: READABLE_STRING_GENERAL; value: G]]
		do
		end

end

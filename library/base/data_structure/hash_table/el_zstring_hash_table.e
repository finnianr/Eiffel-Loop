note
	description: "Summary description for {EL_STRING_HASH_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-31 20:09:33 GMT (Wednesday 31st May 2017)"
	revision: "4"

class
	EL_ZSTRING_HASH_TABLE [G]

inherit
	EL_HASH_TABLE [G, ZSTRING]
		rename
			make as make_table, append_tuples as append_tuples_table
		export
			{NONE} append_tuples_table
		redefine
			force, put, extend
		end

create
	default_create, make, make_equal, make_size

feature {NONE} -- Initialization

	make (array: like GENERAL_KEYS)
			--
		do
			make_table (augmented_latin_keys (array))
		end

feature -- Element change


	append_tuples (array: like GENERAL_KEYS)
		do
			append_tuples_table (augmented_latin_keys (array))
		end

	extend (new: G; key: ZSTRING)
		do
			if attached {like key_set} key_set as l_key_set then
				l_key_set.put (key)
				Precursor (new, l_key_set.found_item)
			else
				Precursor (new, key)
			end
		end

	force (new: G; key: ZSTRING)
		do
			if attached {like key_set} key_set as l_key_set then
				l_key_set.put (key)
				Precursor (new, l_key_set.found_item)
			else
				Precursor (new, key)
			end
		end

	put (new: G; key: ZSTRING)
		do
			if attached {like key_set} key_set as l_key_set then
				l_key_set.put (key)
				Precursor (new, l_key_set.found_item)
			else
				Precursor (new, key)
			end
		end

	set_key_set (a_key_set: like key_set)
		do
			key_set := a_key_set
		end

feature {NONE} -- Implementation

	augmented_latin_keys (array: like GENERAL_KEYS): ARRAY [TUPLE [ZSTRING, G]]
			-- Convert to keys to type ZSTRING
		local
			tuple_item: like GENERAL_KEYS.item
			i: INTEGER; key: ZSTRING
		do
			create Result.make (1, array.count)
			from i := 1 until i > array.count loop
				tuple_item := array [i]
				if attached {ZSTRING} tuple_item.key as astring_key then
					key := astring_key
				else
					create key.make_from_general (tuple_item.key)
				end
				Result [i] := [key, tuple_item.value]
				i := i + 1
			end
		end

	key_set: detachable EL_HASH_SET [ZSTRING]

feature {NONE} -- Type definitions

	GENERAL_KEYS: ARRAY [TUPLE [key: READABLE_STRING_GENERAL; value: G]]
		do
		end

end

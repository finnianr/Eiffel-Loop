note
	description: "Summary description for {EL_STRING_HASH_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-15 9:53:07 GMT (Wednesday 15th January 2014)"
	revision: "4"

class
	EL_ASTRING_HASH_TABLE [G]

inherit
	EL_HASH_TABLE [G, ASTRING]
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

	extend (new: G; key: ASTRING)
		do
			if attached {like key_set} key_set as l_key_set then
				l_key_set.put (key)
				Precursor (new, l_key_set.found_item)
			else
				Precursor (new, key)
			end
		end

	force (new: G; key: ASTRING)
		do
			if attached {like key_set} key_set as l_key_set then
				l_key_set.put (key)
				Precursor (new, l_key_set.found_item)
			else
				Precursor (new, key)
			end
		end

	put (new: G; key: ASTRING)
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

	augmented_latin_keys (array: like Type_general_keys): ARRAY [TUPLE [ASTRING, G]]
			-- Convert to keys to type EL_ASTRING
		local
			i: INTEGER
			key: ASTRING
			tuple_item: like Type_general_keys.item
		do
			create Result.make (1, array.count)
			from i := 1 until i > array.count loop
				tuple_item := array [i]
				if attached {ASTRING} tuple_item.key as astring_key then
					key := astring_key
				else
					create key.make_from_unicode (tuple_item.key)
				end
				Result [i] := [key, tuple_item.value]
				i := i + 1
			end
		end

	key_set: detachable EL_HASH_SET [ASTRING]

feature {NONE} -- Type definitions

	Type_general_keys: ARRAY [TUPLE [key: READABLE_STRING_GENERAL; value: G]]
		do
		end

end

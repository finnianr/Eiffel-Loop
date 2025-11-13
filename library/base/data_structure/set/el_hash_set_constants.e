note
	description: "Hash SET constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-11-13 6:25:42 GMT (Thursday 13th November 2025)"
	revision: "2"

class
	EL_HASH_SET_CONSTANTS

feature {NONE} -- Compare constants

	Compare_expanded: NATURAL_8 = 1

	Compare_is_equal: NATURAL_8 = 2

	Compare_reference: NATURAL_8 = 3

	Compare_with_test: NATURAL_8 = 4

feature {NONE} -- Status constants

	Changed: INTEGER = 3
		-- Change successful

	Found_constant: INTEGER = 2
		-- Key found

	Insertion_conflict: INTEGER = 5
		-- Could not insert an already existing key

	Insertion_ok: INTEGER = 1
		-- Insertion successful

	Not_found_constant: INTEGER = 6
		-- Key not found

	Removed: INTEGER = 4
		-- Remove successful

feature {NONE} -- Constants

	Size_threshold: INTEGER = 80
		-- Filling percentage over which some resizing is done


end
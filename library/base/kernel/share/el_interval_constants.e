note
	description: "[
		Constants to represent state of 2 integer bounds A and B which may be
		overlapping or disjointed.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-03 7:30:51 GMT (Saturday 3rd May 2025)"
	revision: "6"

deferred class
	EL_INTERVAL_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	A_overlaps_B_left: INTEGER = 0x11

	A_overlaps_B_right: INTEGER = 0x12

	B_contains_A: INTEGER = 0x13

	A_contains_B: INTEGER = 0x14

	A_left_of_B: INTEGER = 0x25

	A_right_of_B: INTEGER = 0x26

	Overlapping_mask: INTEGER = 0x10

	Disjoint_mask: INTEGER = 0x20

end
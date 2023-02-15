note
	description: "Constants to represent state of overlapping/disjoint integer intervals"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-15 12:01:25 GMT (Wednesday 15th February 2023)"
	revision: "2"

deferred class
	EL_INTERVAL_CONSTANTS

inherit
	EL_ANY_SHARED

feature -- Constants

	a_overlaps_b_left: INTEGER = 0x11

	a_overlaps_b_right: INTEGER = 0x12

	b_contains_a: INTEGER = 0x13

	a_contains_b: INTEGER = 0x14

	a_left_of_b: INTEGER = 0x25

	a_right_of_b: INTEGER = 0x26

	Overlapping_mask: INTEGER = 0x10

	Disjoint_mask: INTEGER = 0x20

end
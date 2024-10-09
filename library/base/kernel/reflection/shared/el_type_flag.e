note
	description: "[
		Flags corresponding to macros defined in `rt_struct.h'

			IS_DEAD: NATURAL_16 =			0x4000
			IS_FROZEN: NATURAL_16 =			0x2000
			IS_DEFERRED: NATURAL_16 =			0x1000
			IS_COMPOSITE: NATURAL_16 =			0x0800
			HAS_DISPOSE: NATURAL_16 =			0x0400
			IS_EXPANDED: NATURAL_16 =			0x0200
			IS_DECLARED_EXPANDED: NATURAL_16 =	0x0100
			
		Plus two extra: `Is_special' and `Is_tuple'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-09 11:36:04 GMT (Wednesday 9th October 2024)"
	revision: "1"

class
	EL_TYPE_FLAG

feature -- Constants

	Has_dispose: NATURAL_16 = 0x0400

	Is_composite: NATURAL_16 = 0x0800

	Is_dead: NATURAL_16 = 0x4000

	Is_declared_expanded: NATURAL_16 = 0x0100

	Is_deferred: NATURAL_16 = 0x1000

	Is_expanded: NATURAL_16 = 0x0200

	Is_frozen: NATURAL_16 = 0x2000

	Is_special: NATURAL_16 = 0x80

	Is_tuple: NATURAL_16 = 0x40

end
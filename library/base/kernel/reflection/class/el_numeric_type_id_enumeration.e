note
	description: "Numeric type identifier enumerations for inclusion in class ${EL_CLASS_TYPE_ID_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-17 10:52:03 GMT (Monday 17th March 2025)"
	revision: "2"

class
	EL_NUMERIC_TYPE_ID_ENUMERATION

feature -- Type sets

	integer_types: SPECIAL [INTEGER]
		-- set of INTEGER_x types including reference variations

	natural_types: SPECIAL [INTEGER]
		-- set of NATURAL_x types including reference variations

	real_types: SPECIAL [INTEGER]
		-- set of REAL_x types including reference variations

feature -- INTEGER types

	INTEGER_16: INTEGER

	INTEGER_32: INTEGER

	INTEGER_64: INTEGER

	INTEGER_8: INTEGER

feature -- NATURAL types

	NATURAL_16: INTEGER

	NATURAL_32: INTEGER

	NATURAL_64: INTEGER

	NATURAL_8: INTEGER

feature -- REAL types

	REAL_32: INTEGER

	REAL_64: INTEGER

end
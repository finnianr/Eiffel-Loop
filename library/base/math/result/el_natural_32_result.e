note
	description: "Implementation of ${EL_NUMERIC_RESULT [NUMERIC]} for ${NATURAL_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-02 14:06:48 GMT (Monday 2nd September 2024)"
	revision: "1"

class
	EL_NATURAL_32_RESULT

inherit
	EL_NUMERIC_RESULT [NATURAL_32]

feature -- Element change

	add (n: NATURAL_32)
		do
			result_ := result_ + n
		end

	set_max (n: NATURAL_32)
		do
			result_ := n.max (result_)
		end

	set_to_min_value
		local
			n: NATURAL_32
		do
			result_ := n.Min_value
		end

end
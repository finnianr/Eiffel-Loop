note
	description: "Implementation of ${EL_NUMERIC_RESULT [REAL_32]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-30 7:48:08 GMT (Monday 30th September 2024)"
	revision: "4"

class
	EL_REAL_32_RESULT

inherit
	EL_NUMERIC_RESULT [REAL_32]

feature -- Element change

	add (n: REAL_32)
		do
			value := value + n
		end

	set_max (n: REAL_32)
		do
			value := n.max (value)
		end

	set_min (n: REAL_32)
		do
			value := n.min (value)
		end

	set_to_max_value
		local
			n: REAL_32
		do
			value := n.Max_value
		end

	set_to_min_value
		local
			n: REAL_32
		do
			value := n.Min_value
		end

end
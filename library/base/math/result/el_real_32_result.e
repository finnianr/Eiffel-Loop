note
	description: "Implementation of ${EL_NUMERIC_RESULT [REAL_32]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-28 10:55:10 GMT (Saturday 28th September 2024)"
	revision: "3"

class
	EL_REAL_32_RESULT

inherit
	EL_NUMERIC_RESULT [REAL_32]

feature -- Element change

	add (n: REAL_32)
		do
			result_ := result_ + n
		end

	set_max (n: REAL_32)
		do
			result_ := n.max (result_)
		end

	set_min (n: REAL_32)
		do
			result_ := n.min (result_)
		end

	set_to_max_value
		local
			n: REAL_32
		do
			result_ := n.Max_value
		end

	set_to_min_value
		local
			n: REAL_32
		do
			result_ := n.Min_value
		end

end
note
	description: "Implementation of ${EL_NUMERIC_RESULT [NATURAL_8]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-03 7:04:34 GMT (Tuesday 3rd September 2024)"
	revision: "2"

class
	EL_NATURAL_8_RESULT

inherit
	EL_NUMERIC_RESULT [NATURAL_8]

feature -- Element change

	add (n: NATURAL_8)
		do
			result_ := result_ + n
		end

	set_max (n: NATURAL_8)
		do
			result_ := n.max (result_)
		end

	set_to_min_value
		local
			n: NATURAL_8
		do
			result_ := n.Min_value
		end

end
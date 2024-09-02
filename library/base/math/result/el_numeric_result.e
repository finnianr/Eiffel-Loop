note
	description: "Abstraction to accumulate a ${NUMERIC} result over repeated operations"
	descendants: "[
			EL_NUMERIC_RESULT* [N -> ${NUMERIC}]
				${EL_REAL_32_RESULT}
				${EL_REAL_64_RESULT}
				${EL_INTEGER_32_RESULT}
				${EL_NATURAL_32_RESULT}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-02 14:40:15 GMT (Monday 2nd September 2024)"
	revision: "1"

deferred class
	EL_NUMERIC_RESULT [N -> NUMERIC]

feature -- Access

	result_: N

feature -- Element change

	set_to_zero
		local
			n: N
		do
			result_ := n.zero
		end

	set_to_min_value
		deferred
		end

feature -- Element change

	add (n: N)
		deferred
		end

	set_max (n: N)
		deferred
		end

end
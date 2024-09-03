note
	description: "Abstraction to accumulate a ${NUMERIC} result over repeated operations"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-03 7:22:27 GMT (Tuesday 3rd September 2024)"
	revision: "2"

deferred class
	EL_NUMERIC_RESULT [N -> NUMERIC]

feature -- Access

	result_: N

	result_type: TYPE [NUMERIC]
		do
			Result := {N}
		end

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

note
	descendants: "[
			EL_NUMERIC_RESULT* [N -> ${NUMERIC}]
				${EL_REAL_32_RESULT}
				${EL_REAL_64_RESULT}
				${EL_INTEGER_32_RESULT}
				${EL_NATURAL_32_RESULT}
				${EL_INTEGER_16_RESULT}
				${EL_INTEGER_64_RESULT}
				${EL_NATURAL_8_RESULT}
				${EL_NATURAL_16_RESULT}
				${EL_NATURAL_64_RESULT}
				${EL_INTEGER_8_RESULT}
	]"
end
note
	description: "Abstraction to accumulate a ${NUMERIC} result over repeated operations"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-30 7:48:25 GMT (Monday 30th September 2024)"
	revision: "4"

deferred class
	EL_NUMERIC_RESULT [N -> NUMERIC]

feature -- Access

	value: N

	value_type: TYPE [NUMERIC]
		do
			Result := {N}
		end

feature -- Element change

	set_to_zero
		local
			n: N
		do
			value := n.zero
		end

	set_to_max_value
		deferred
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

	set_min (n: N)
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
note
	description: "Compare call on expanded vs once ref object"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "7"

class
	ROUTINE_CALL_ON_ONCE_VS_EXPANDED

inherit
	EL_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "Call on expanded vs once ref object"

feature -- Basic operations

	execute
		do
			compare ("Expand to once", <<
				["do_nothing on expanded local", agent expanded_local_target],
				["do_nothing on expanded", 		agent expanded_target],
				["do_nothing on once ref",			agent once_target]
			>>)
		end

feature {NONE} -- el_os_routines_i

	expanded_local_target
		local
			i: INTEGER; obj: EXPANDED_ANY
		do
			from i := 1 until i > 10_000 loop
				obj.do_nothing
				i := i + 1
			end
		end

	expanded_target
		local
			i: INTEGER
		do
			from i := 1 until i > 10_000 loop
				expanded_any.do_nothing
				i := i + 1
			end
		end

	once_target
		local
			i: INTEGER
		do
			from i := 1 until i > 10_000 loop
				Once_ref.do_nothing
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	expanded_any: EXPANDED_ANY
		do
		end

feature {NONE} -- Constants

	Once_ref: ANY
		once
			create Result
		end

end
note
	description: "Compare filling [$source LINKED_LIST] with filling [$source ARRAYED_LIST]"
	notes: "[
		Passes over 500 millisecs (in descending order)

			ARRAYED_LIST : 16331.0 times (100%)
			LINKED_LIST  :   495.0 times (-97.0%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-24 10:38:47 GMT (Wednesday 24th May 2023)"
	revision: "6"

class
	ARRAYED_VS_LINKED_LIST

inherit
	EL_BENCHMARK_COMPARISON

create
	make

feature -- Access

	Description: STRING = "Filling linked VS arrayed list"

feature -- Basic operations

	execute
		do
			compare ("Fill list with numbers 1 to 1000", <<
				["LINKED_LIST", agent fill_linked_list],
				["ARRAYED_LIST", agent fill_arrayed_list]
			>>)
		end

feature {NONE} -- el_os_routines_i

	fill_linked_list
		local
			i: INTEGER; list: LINKED_LIST [INTEGER]
		do
			create list.make
			from i := 1 until i > 1_000 loop
				list.extend (i)
				i := i + 1
			end
		end

	fill_arrayed_list
		local
			i: INTEGER; list: ARRAYED_LIST [INTEGER]
		do
			create list.make (500)
			from i := 1 until i > 1_000 loop
				list.extend (i)
				i := i + 1
			end
		end

end
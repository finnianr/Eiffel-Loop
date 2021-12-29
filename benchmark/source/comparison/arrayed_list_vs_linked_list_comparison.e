note
	description: "Compare filling [$source LINKED_LIST] with filling [$source ARRAYED_LIST]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-29 16:05:37 GMT (Wednesday 29th December 2021)"
	revision: "1"

class
	ARRAYED_LIST_VS_LINKED_LIST_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

create
	make

feature -- Basic operations

	execute
		do
			compare ("Fill Linked VS Arrayed list", <<
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
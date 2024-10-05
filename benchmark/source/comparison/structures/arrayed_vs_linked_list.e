note
	description: "Compare filling ${LINKED_LIST} with filling ${ARRAYED_LIST}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-04 12:14:07 GMT (Friday 4th October 2024)"
	revision: "8"

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
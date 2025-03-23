note
	description: "Once off comparisons for developer testing"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-23 7:53:05 GMT (Sunday 23rd March 2025)"
	revision: "13"

class
	DEVELOPER_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	TIME_CONSTANTS

	EL_MODULE_EIFFEL

create
	make

feature -- Access

	Description: STRING = "Development method comparisons"

feature -- Basic operations

	execute
		local
			ref_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
			range: INTEGER_INTERVAL
		do
			range := 1 |..| 500
			create ref_list.make (range.count)
			across range as n loop
				ref_list.extend (create {STRING_8}.make_empty)
			end
			ref_list.extend (create {ZSTRING}.make_empty)

			compare ("perform benchmark", <<
				["method 1", agent do_method (1, ref_list)],
				["method 2", agent do_method (2, ref_list)],
				["method 3", agent do_method (3, ref_list)]
--				["method 4", agent do_method (4, ref_list)],
--				["method 5", agent do_method (4, ref_list)]
			>>)
		end

feature {NONE} -- Operations

	do_method (id: INTEGER; ref_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL])
		local
			i: INTEGER; exists: BOOLEAN
		do
			from until i > Repetition_count loop
				inspect id
					when 1 then
						if attached {EL_STRING_FIELD_REPRESENTATION [INTEGER, ANY]} representation as l_rep then
							do_nothing
						else
							counter := counter + 1
						end
					when 2 then
						if representation = Void then
							counter := counter + 1

						elseif attached {EL_STRING_FIELD_REPRESENTATION [INTEGER, ANY]} representation as l_rep then
							do_nothing
						end
					when 3 then
						if has_representation
							and then attached {EL_STRING_FIELD_REPRESENTATION [INTEGER, ANY]} representation as l_rep
						then
							do_nothing
						else
							counter := counter + 1
						end
				end
				i := i + 1
			end
		end

feature {NONE} -- Internal attributes

	has_representation: BOOLEAN

	representation: detachable EL_FIELD_REPRESENTATION [INTEGER, ANY]

	counter: NATURAL

feature {NONE} -- Constants

	Repetition_count: INTEGER = 5_000

end
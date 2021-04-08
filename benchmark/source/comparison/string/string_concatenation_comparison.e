note
	description: "Compare various ways of concatenating strings"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-08 9:05:59 GMT (Thursday 8th April 2021)"
	revision: "5"

class
	STRING_CONCATENATION_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

create
	make

feature -- Basic operations

	execute
		local
			array: ARRAYED_LIST [STRING]
		do
			create array.make ((('z').natural_32_code - ('A').natural_32_code + 1).to_integer_32)
			from until array.full loop
				array.extend (create {STRING}.make_filled (('A').plus (array.count), 100))
			end
			compare ("compare_list_iteration_methods", <<
				["append strings to Result", 							agent string_append (array)],
				["append strings to once string", 					agent string_append_once_string (array)],
				["append strings to once string with local",		agent string_append_once_string_with_local (array)]
			>>)
		end

feature {NONE} -- String append variations

	string_append (array: ARRAYED_LIST [STRING]): STRING
		do
			create Result.make_empty
			from array.start until array.after loop
				Result.append (array.item)
				array.forth
			end
			Result.trim
		end

	string_append_once_string (array: ARRAYED_LIST [STRING]): STRING
		do
			Once_string.wipe_out
			from array.start until array.after loop
				Once_string.append (array.item)
				array.forth
			end
			Result := Once_string.twin
		end

	string_append_once_string_with_local (array: ARRAYED_LIST [STRING]): STRING
		local
			l_result: STRING
		do
			l_result := Once_string
			l_result.wipe_out
			from array.start until array.after loop
				l_result.append (array.item)
				array.forth
			end
			Result := l_result.twin
		end

feature {NONE} -- Constants

	Once_string: STRING
		once
			create Result.make_empty
		end

end
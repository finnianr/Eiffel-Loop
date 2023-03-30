note
	description: "Compare iterating immutable VS changeable string list"
	notes: "[
		The shared immutable item iteration is an order of magnitude faster.

		Passes over 1000 millisecs (in descending order)

			EL_SPLIT_IMMUTABLE_STRING_32_LIST : 14605.0 times (100%)
			EL_SPLIT_STRING_32_LIST           :  4359.0 times (-70.2%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-30 12:30:49 GMT (Thursday 30th March 2023)"
	revision: "13"

class
	IMMUTABLE_STRING_SPLIT_COMPARISON

inherit
	STRING_BENCHMARK_COMPARISON

	HEXAGRAM_NAMES
		export
			{NONE} all
		end

create
	make

feature -- Access

	Description: STRING = "Iterating immutable VS changeable list"

feature -- Basic operations

	execute
		local
			split_list: EL_SPLIT_STRING_32_LIST
		do
			create split_list.make_adjusted (Name_manifest, ',', {EL_SIDE}.Left)

			compare ("compare split list iteration", <<
				["EL_SPLIT_STRING_32_LIST", agent changeable_split_list (split_list)],
				["EL_SPLIT_IMMUTABLE_STRING_32_LIST", agent immutable_split_list (Name_grid)]
			>>)
		end

feature {NONE} -- Operations

	changeable_split_list (list: EL_SPLIT_STRING_32_LIST)
		local
			count: INTEGER
		do
			from list.start until list.after loop
				count := list.item.count
				list.forth
			end
		end

	immutable_split_list (list: EL_SPLIT_IMMUTABLE_STRING_32_LIST)
		local
			count: INTEGER
		do
			from list.start until list.after loop
				count := list.item.count
				list.forth
			end
		end

end
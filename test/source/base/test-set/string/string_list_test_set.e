note
	description: "String list test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-24 15:49:43 GMT (Friday 24th January 2020)"
	revision: "4"

class
	STRING_LIST_TEST_SET

inherit
	EQA_TEST_SET

	EL_STRING_8_CONSTANTS

	EL_MODULE_LIO

feature -- Tests

	test_path_split
		local
			split_path_8: LIST [STRING]
			split_path: EL_SPLIT_ZSTRING_LIST
		do
			split_path_8 := Unix_path.split ('/')
			create split_path.make (Unix_path, "/")
			assert (
				"all steps are equal",
				across split_path_8 as step all step.item ~ split_path.i_th (step.cursor_index).to_string_8 end
			)
		end

	test_split_and_join_1
		local
			split_numbers: EL_STRING_LIST [STRING]
		do
			create split_numbers.make_with_separator (Numbers, ',', False)
			assert ("same string", Numbers ~ split_numbers.joined (','))

			split_numbers := << "one", "two", "three" >>
			assert ("same string", Numbers ~ split_numbers.joined (','))
		end

	test_split_and_join_2
		local
			split_numbers: EL_SPLIT_ZSTRING_LIST
		do
			create split_numbers.make (Numbers, ",")
			assert ("same string", Numbers ~ split_numbers.joined (','))
		end

	test_split_string_8
		local
			list: EL_SPLIT_STRING_LIST [STRING]
		do
			lio.enter ("test_split_string_8")
			create list.make (Api_string_list.joined_with_string (Comma_space), character_string_8 (','))
			list.enable_left_adjust
			lio.put_string_field ("left_adjusted", list.left_adjusted.out)
			lio.put_new_line
			from list.start until list.after loop
				lio.put_integer_interval_field ("interval " + list.index.out, list.item_start_index |..| list.item_end_index)
				lio.put_new_line
				lio.put_line (Api_string_list.i_th (list.index))
				lio.put_line (list.item)
				assert ("same item", list.item ~ Api_string_list.i_th (list.index))
				list.forth
			end
			lio.exit
		end

	test_occurrence_intervals
		local
			intervals: EL_OCCURRENCE_INTERVALS [STRING]
			str: STRING; item_lower, item_upper: INTEGER
		do
			create intervals.make (Api_string_list.joined_with_string (Comma_space), Comma_space)
			create str.make (Api_string.count)
			across Api_string_list as api loop
				if not str.is_empty then
					item_lower := str.count + 1
					str.append (Comma_space)
					item_upper := str.count
					intervals.go_i_th (api.cursor_index - 1)
					assert ("same item_lower", item_lower = intervals.item_lower)
					assert ("same item_upper", item_upper = intervals.item_upper)
				end
				str.append (api.item)
			end
		end

feature {NONE} -- Constants

	Comma_space: STRING = ", "

	Api_string: STRING = "[
		DTA1-HMAC-SHA256 SignedHeaders=content-length;content-type;host;x-amz-date
		Credential=PUBLIC/20200124
		Signature=B7387390DEC2CD5A515B67EE50D220A3EE4507DC2F71EA67F59BDB0DE9FF403B
	]"

	Api_string_list: EL_STRING_8_LIST
		once
			create Result.make_with_lines (Api_string)
		end

	Numbers: STRING = "one,two,three"

	Unix_path: STRING = "/home/joe"
end

note
	description: "Arrayed list test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 11:47:25 GMT (Wednesday 8th January 2020)"
	revision: "3"

class
	ARRAYED_LIST_TEST_SET

inherit
	EQA_TEST_SET

feature -- Tests

	test_shift
		local
			list: EL_ARRAYED_LIST [CHARACTER]
		do
			create list.make_from_array (<< 'a', 'b', 'c', 'd' >>)
			list.shift_i_th (2, 2)
			assert ("valid shift", to_string (list) ~ "acdb")
			list.shift_i_th (4, -3)
			assert ("valid shift", to_string (list) ~ "bacd")
			list.shift_i_th (1, 1)
			assert ("valid shift", to_string (list) ~ "abcd")
		end

feature {NONE} -- Implementation

	to_string (list: EL_ARRAYED_LIST [CHARACTER]): STRING
		do
			create Result.make (list.count)
			list.do_all (agent Result.extend)
		end
end

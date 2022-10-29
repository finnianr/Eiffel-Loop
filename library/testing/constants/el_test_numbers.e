﻿note
	description: "Test numbers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 9:06:44 GMT (Saturday 29th October 2022)"
	revision: "1"

class
	EL_TEST_NUMBERS

feature -- Conversion

	double_to_string (n: DOUBLE): STRING
		do
			Result := n.out
			if Result.ends_with ("001") then
				 Result.remove_tail (1)
				 Result.prune_all_trailing ('0')
			end
		end

feature -- Constants

	doubles_list: ARRAY [DOUBLE]
		once
			Result := << 1.23, 1, 10, 12.3, 12.3, 123, -1, -10, -1.23, -12.3, -123 >>
		end

end
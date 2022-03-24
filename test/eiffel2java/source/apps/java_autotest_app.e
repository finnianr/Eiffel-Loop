note
	description: "Execute test set [$source JAVA_TEST_SET]"
	notes: "[
		Launch option: `-java_autotest'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-24 12:58:39 GMT (Thursday 24th March 2022)"
	revision: "4"

class
	JAVA_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [JAVA_TEST_SET]
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Implementation

	visible_types: TUPLE [JAVA_ENVIRONMENT]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end
end
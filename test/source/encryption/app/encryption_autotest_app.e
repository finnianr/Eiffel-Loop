note
	description: "Sub-application to call tests in [$source DIGEST_ROUTINES_TEST_SET]"
	instructions: "Command option: `-encryption_autotest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 9:28:20 GMT (Thursday 23rd January 2020)"
	revision: "2"

class
	ENCRYPTION_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	evaluator_type, evaluator_types_all: TUPLE [DIGEST_ROUTINES_TEST_EVALUATOR]
		do
			create Result
		end
end

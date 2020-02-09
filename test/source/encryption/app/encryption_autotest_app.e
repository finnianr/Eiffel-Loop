note
	description: "Sub-application to call tests in [$source DIGEST_ROUTINES_TEST_SET]"
	instructions: "Command option: `-encryption_autotest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-07 10:20:24 GMT (Friday 7th February 2020)"
	revision: "3"

class
	ENCRYPTION_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	evaluator_type: TUPLE [ENCRYPTION_TEST_EVALUATOR]
		do
			create Result
		end

	evaluator_types_all: TUPLE [
		DIGEST_ROUTINES_TEST_EVALUATOR,
		ENCRYPTION_TEST_EVALUATOR
	]
		do
			create Result
		end
end

note
	description: "Encryption autotest app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 13:18:51 GMT (Wednesday 8th January 2020)"
	revision: "1"

class
	ENCRYPTION_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [DIGEST_ROUTINES_TEST_SET]
		do
			create Result
		end

	evaluator_type, evaluator_types_all: TUPLE
		do
			create Result
		end
end

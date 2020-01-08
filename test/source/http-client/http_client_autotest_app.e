note
	description: "Sub-application to aid development of AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 14:12:29 GMT (Wednesday 8th January 2020)"
	revision: "61"

class
	HTTP_CLIENT_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	evaluator_type, evaluator_types_all: TUPLE [
		HTTP_CONNECTION_TEST_EVALUATOR
	]
		do
			create Result
		end

end

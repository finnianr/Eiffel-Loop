note
	description: "Sub-application to aid development of AutoTest classes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 14:04:11 GMT (Wednesday 8th January 2020)"
	revision: "61"

class
	I18N_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

--	Tests that still need an evaluator
	compile: TUPLE [TRANSLATION_TABLE_TEST_SET]
		do
			create Result
		end

	evaluator_type, evaluator_types_all: TUPLE
		do
			create Result
		end

end

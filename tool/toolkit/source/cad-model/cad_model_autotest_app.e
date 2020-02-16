note
	description: "Evaluate test set [$source CAD_MODEL_TEST_SET]"
	notes: "Command option: `-cad_model_autotest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-16 11:58:59 GMT (Sunday 16th February 2020)"
	revision: "1"

class
	CAD_MODEL_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type, test_types_all: TUPLE [CAD_MODEL_TEST_SET]
		do
			create Result
		end

end

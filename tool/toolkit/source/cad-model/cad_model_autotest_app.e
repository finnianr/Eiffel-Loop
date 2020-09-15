note
	description: "Evaluate test set [$source CAD_MODEL_TEST_SET]"
	notes: "Command option: `-cad_model_autotest'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-15 10:26:45 GMT (Tuesday 15th September 2020)"
	revision: "2"

class
	CAD_MODEL_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [TUPLE [CAD_MODEL_TEST_SET]]

create
	make

end
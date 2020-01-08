note
	description: "Text process autotest app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 13:00:44 GMT (Wednesday 8th January 2020)"
	revision: "1"

class
	TEXT_PROCESS_AUTOTEST_APP

inherit
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	compile: TUPLE []
		do
			create Result
		end

	evaluator_type, evaluator_types_all: TUPLE
		do
			create Result
		end
end

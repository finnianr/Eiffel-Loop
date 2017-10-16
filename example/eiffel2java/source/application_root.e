note
	description: "Summary description for {APPLICATION_ROOT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Implementation

	Application_types: ARRAY [TYPE [EL_SUB_APPLICATION]]
			--
		once
			Result := <<
				{APACHE_VELOCITY_TEST_APP},
				{JAVA_TEST_APP},
				{SVG_TO_PNG_TEST_APP}
			>>
		end

	notes: TUPLE [DONE_LIST, TO_DO_LIST]
		do
		end

end
note
	description: "Summary description for {APPLICATION_ROOT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-30 13:59:46 GMT (Thursday 30th June 2016)"
	revision: "3"

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
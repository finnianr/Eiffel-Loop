note
	description: "[
		Calls ${JAVA_AUTOTEST_APP} and ${VELOCITY_AUTOTEST_APP} as external applications
		(This ensures JNI VM is removed between tests)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	AUTOTEST_APP

inherit
	EL_BATCH_AUTOTEST_APP

create
	make
end
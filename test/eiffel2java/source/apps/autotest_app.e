note
	description: "[
		Calls ${JAVA_AUTOTEST_APP} and ${VELOCITY_AUTOTEST_APP} as external applications
		(This ensures JNI VM is removed between tests)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	AUTOTEST_APP

inherit
	EL_BATCH_AUTOTEST_APP

create
	make
end
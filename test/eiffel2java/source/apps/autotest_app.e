note
	description: "[
		Calls [$source JAVA_AUTOTEST_APP] and [$source VELOCITY_AUTOTEST_APP] as external applications
		(This ensures JNI VM is removed between tests)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-08 14:57:05 GMT (Saturday 8th January 2022)"
	revision: "1"

class
	AUTOTEST_APP

inherit
	EL_BATCH_AUTOTEST_APP

create
	make
end
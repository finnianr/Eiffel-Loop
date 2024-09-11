note
	description: "[
		Calls ${JAVA_AUTOTEST_APP} and ${VELOCITY_AUTOTEST_APP} as external applications
		(This ensures JNI VM is removed between tests)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-10 9:01:12 GMT (Tuesday 10th September 2024)"
	revision: "4"

class
	AUTOTEST_APP

inherit
	EL_BATCH_AUTOTEST_APP
		rename
			omitted_apps as none_omitted
		end

create
	make
end
note
	description: "[
		Calls [$source JAVA_AUTOTEST_APP] and [$source VELOCITY_AUTOTEST_APP] as external applications
		(This ensures JNI VM is removed between tests)
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUTOTEST_APP

inherit
	EL_BATCH_AUTOTEST_APP

create
	make
end

note
	description: "Execute test set [$source VELOCITY_TEST_SET]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VELOCITY_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [VELOCITY_TEST_SET]
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Implementation

	visible_types: TUPLE [JAVA_ENVIRONMENT_IMP]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

end

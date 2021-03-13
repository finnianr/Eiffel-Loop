note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-06 16:55:00 GMT (Friday 6th November 2020)"
	revision: "8"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		EL_BATCH_TEST_APP, JAVA_AUTOTEST_APP, VELOCITY_AUTOTEST_APP
	]

create
	make

feature {NONE} -- Constants

	Compile_also: TUPLE [J_COLOR, J_FILE, SVG_TO_PNG_TEST_SET]
		do
			create Result
		end

note
	to_do: "[
		**c_compiler_warnings**
		
		Find out why addition of -Wno-write-strings does not suppress java warnings
		$ISE_EIFFEL/studio/spec/$ISE_PLATFORM/include/config.sh

		warning: deprecated conversion from string constant to 'char*' [-Wwrite-strings]

		**autotest**
		Make AutoTest suites
	]"

end

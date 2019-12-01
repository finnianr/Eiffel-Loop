note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-01 12:34:41 GMT (Sunday 1st December 2019)"
	revision: "6"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Constants

	Applications: TUPLE [APACHE_VELOCITY_TEST_APP, JAVA_TEST_APP, SVG_TO_PNG_TEST_APP]
		once
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

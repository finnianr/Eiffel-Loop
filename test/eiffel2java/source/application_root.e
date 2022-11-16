note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		AUTOTEST_APP,
		JAVA_AUTOTEST_APP,
		VELOCITY_AUTOTEST_APP
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
	]"

end
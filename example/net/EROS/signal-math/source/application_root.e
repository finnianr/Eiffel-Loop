note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO,
		BEXT_CLIENT_TEST_APP,
		BEXT_SERVER_TEST_APP,
		FFT_MATH_CLIENT_TEST_APP,
		FFT_MATH_SERVER_TEST_APP,
		EL_STANDARD_INSTALLER_APP
	]

create
	make

end
note
	description: "Unix application root with some additional sub-applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-19 11:43:11 GMT (Saturday 19th April 2025)"
	revision: "81"

class
	APPLICATION_ROOT

inherit
	COMMON_APPLICATION_ROOT
		redefine
			create_singletons, new_platform_types
		end

	EL_UNIX_IMPLEMENTATION

create
	make

feature {NONE} -- Implementation

	create_singletons
		do
			Precursor
			-- Ensure LD_LIBRARY_PATH set for Unix
			Execution_environment.set_library_path
		end

	new_platform_types: TUPLE [
	-- Test fast-cgi.ecf
		FAST_CGI_TEST_APP, HACKER_INTERCEPT_TEST_SERVICE_APP,

	-- Test TagLib.ecf (Not yet available in Windows due to contrib/C++ links to external library)
		TAGLIB_AUTOTEST_APP,

	-- multi-media.ecf
		MULTIMEDIA_AUTOTEST_APP
	]
		-- extra platform specific types to supplement `new_application_types'
		do
			create Result
		end

end
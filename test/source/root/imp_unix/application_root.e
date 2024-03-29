note
	description: "Unix application root with some additional sub-applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 14:16:28 GMT (Monday 1st January 2024)"
	revision: "78"

class
	APPLICATION_ROOT

inherit
	COMMON_APPLICATION_ROOT
		redefine
			create_singletons, new_platform_types
		end

	COMPILED_CLASSES

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
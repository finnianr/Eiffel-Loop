note
	description: "Application root"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-27 18:15:06 GMT (Sunday 27th May 2018)"
	revision: "4"

class
	APPLICATION_ROOT

inherit
	EL_MULTI_APPLICATION_ROOT [BUILD_INFO]

create
	make

feature {NONE} -- Implementation

	Application_types: ARRAY [TYPE [EL_SUB_APPLICATION]]
			--
		once
			Result := <<
				{BEXT_CLIENT_TEST_APP},
				{BEXT_SERVER_TEST_APP},
				{FOURIER_MATH_TEST_CLIENT_APP},
				{FOURIER_MATH_TEST_SERVER_APP},
				{EL_STANDARD_INSTALLER_APP}
			>>
		end

end

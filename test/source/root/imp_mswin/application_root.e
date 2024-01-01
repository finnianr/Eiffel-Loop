note
	description: "Windows application root with some additional sub-applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 14:16:51 GMT (Monday 1st January 2024)"
	revision: "1"

class
	APPLICATION_ROOT

inherit
	COMMON_APPLICATION_ROOT
		redefine
			new_platform_types
		end

	COMPILED_CLASSES

create
	make

feature {NONE} -- Implementation

	new_platform_types: TUPLE [
	-- For maintenance purposes only
		MEDIA_PLAYER_DUMMY_APP
	]
		-- extra platform specific types to supplement `new_application_types'
		do
			create Result
		end

end
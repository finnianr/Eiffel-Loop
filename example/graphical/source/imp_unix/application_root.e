note
	description: "Unix implementation of root class ${COMMON_ROOT}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-24 16:31:04 GMT (Tuesday 24th September 2024)"
	revision: "1"

class
	APPLICATION_ROOT

inherit
	COMMON_APPLICATION_ROOT

	EL_UNIX_IMPLEMENTATION

create
	make

feature -- Access

	compile_unix: TUPLE
		do
			create Result
		end

end
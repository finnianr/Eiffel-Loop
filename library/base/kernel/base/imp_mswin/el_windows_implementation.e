note
	description: "Object that is implemented for Windows OS"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-22 8:34:25 GMT (Wednesday 22nd November 2023)"
	revision: "2"

deferred class
	EL_WINDOWS_IMPLEMENTATION

inherit
	ANY
		undefine
			copy, default_create, is_equal, out
		end

feature -- Access

	frozen os_type: NATURAL_8
		do
			Result := 2
		end

end
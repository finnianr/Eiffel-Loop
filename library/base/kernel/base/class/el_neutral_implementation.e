note
	description: "Object that does not have an OS specific implementation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 17:09:03 GMT (Sunday 5th November 2023)"
	revision: "6"

deferred class
	EL_NEUTRAL_IMPLEMENTATION

inherit
	ANY
		undefine
			copy, is_equal
		end

feature -- Access

	frozen os_type: NATURAL_8
		do
			Result := 0
		end

end
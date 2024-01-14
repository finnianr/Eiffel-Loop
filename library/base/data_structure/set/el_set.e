note
	description: "Abstract set of objects with membership test"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-14 13:42:31 GMT (Sunday 14th January 2024)"
	revision: "1"

deferred class
	EL_SET [G]

feature -- Status query

	has (v: G): BOOLEAN
		-- `True' if `v' is a member of set
		deferred
		end
end
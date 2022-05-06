note
	description: "[
		Defines a scope during which an object is created and made available inside the
		an across-loop before being destroyed when exiting the loop.
	]"
	descendants: "[
			EL_ITERABLE_SCOPE* [G]
				[$source EL_BORROWED_OBJECT_SCOPE] [G]
					[$source EL_BORROWED_STRING_SCOPE] [S -> [$source STRING_GENERAL] create make end]
				[$source EL_PACKAGE_IMAGES_SCOPE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-24 7:47:11 GMT (Sunday 24th April 2022)"
	revision: "2"

deferred class
	EL_ITERABLE_SCOPE [G]

inherit
	ITERABLE [G]

feature -- Access

	new_cursor: EL_SCOPE_CURSOR [G]
		do
			create Result.make (Current)
		end

feature {EL_SCOPE_CURSOR} -- Implementation

	new_item: G
		-- called once on entry into across scope
		deferred
		end

	on_exit (item: like new_item)
		-- called on exit from across scope
		deferred
		end

end
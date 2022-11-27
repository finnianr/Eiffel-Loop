note
	description: "Implementation of [$source EL_FACTORY_POOL [STRING_GENERAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_STRING_FACTORY_POOL [S -> STRING_GENERAL create make end]

inherit
	EL_FACTORY_POOL [S]
		redefine
			borrowed_item
		end

create
	make

feature -- Access

	borrowed_item: S
		do
			Result := Precursor
			Result.keep_head (0)
		end

feature {NONE} -- Implementation

	new_item: S
		do
			create Result.make (50)
		end
end
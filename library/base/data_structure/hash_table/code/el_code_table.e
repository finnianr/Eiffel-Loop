note
	description: "Code table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 16:06:17 GMT (Sunday 22nd September 2024)"
	revision: "8"

class
	EL_CODE_TABLE [K -> HASHABLE]

inherit
	EL_HASH_TABLE [INTEGER, K]
		redefine
			make
		end

create
	make

feature -- Initialization

	make (n: INTEGER)
			--
		do
			Precursor (n)
			compare_objects
		end

end
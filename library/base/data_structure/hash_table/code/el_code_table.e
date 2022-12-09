note
	description: "Code table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 9:37:56 GMT (Friday 9th December 2022)"
	revision: "7"

class
	EL_CODE_TABLE [K -> HASHABLE]

inherit
	HASH_TABLE [INTEGER, K]
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
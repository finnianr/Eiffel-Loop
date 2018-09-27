note
	description: "Code table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "5"

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
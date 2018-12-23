note
	description: "Std mutex hash table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_STD_MUTEX_HASH_TABLE [G, H -> HASHABLE]

inherit
	EL_MUTEX_REFERENCE [HASH_TABLE [G, H]]
		rename
			make as make_synchronized
		end

create
	make

feature {NONE} -- Initialization

	make (size: INTEGER)
			--
		do
			make_synchronized (create {HASH_TABLE [G, H]}.make (size))
		end

end

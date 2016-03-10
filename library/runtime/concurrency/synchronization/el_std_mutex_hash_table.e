note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-10 15:46:52 GMT (Sunday 10th May 2015)"
	revision: "2"

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


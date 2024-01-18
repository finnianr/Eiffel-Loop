note
	description: "Shared objects conforming to ${EL_INITIALIZEABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 17:31:14 GMT (Monday 25th December 2023)"
	revision: "9"

deferred class
	EL_SHARED_INITIALIZER [G -> EL_INITIALIZEABLE create make end]

inherit
	EL_SHAREABLE_CACHE_TABLE [EL_INITIALIZEABLE, TYPE [EL_INITIALIZEABLE]]

feature -- Access

	item: G
			--
		do
			if attached {G} shared_item ({G}) as l_result then
				Result := l_result
			else
				create Result.make
			end
		end

feature {EL_SHARED_INITIALIZER} -- Implementation

	new_shared_item (type: TYPE [EL_INITIALIZEABLE]): G
			--
		do
			create Result.make
		end

feature {NONE} -- Constants

	Once_cache_table: HASH_TABLE [EL_INITIALIZEABLE, TYPE [EL_INITIALIZEABLE]]
		once
			create Result.make (11)
		end

end
note
	description: "Shared objects conforming to ${EL_INITIALIZEABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 7:49:14 GMT (Monday 23rd September 2024)"
	revision: "11"

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

	Once_cache_table: EL_HASH_TABLE [EL_INITIALIZEABLE, TYPE [EL_INITIALIZEABLE]]
		once
			create Result.make (11)
		end

end
note
	description: "Shared objects conforming to [$source EL_INITIALIZEABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-27 16:03:53 GMT (Monday 27th January 2020)"
	revision: "5"

deferred class
	EL_SHARED_INITIALIZER [G -> EL_INITIALIZEABLE create make end]

feature -- Access

	item: G
			--
		do
			if attached {G} Item_table.item ({G}) as l_result then
				Result := l_result
			end
		end

feature {EL_SHARED_INITIALIZER} -- Implementation

	new_item (type: TYPE [EL_INITIALIZEABLE]): G
			--
		do
			create Result.make
		end

feature {NONE} -- Constants

	Item_table: EL_CACHE_TABLE [EL_INITIALIZEABLE, TYPE [EL_INITIALIZEABLE]]
		once
			create Result.make (11, agent new_item)
		end

end

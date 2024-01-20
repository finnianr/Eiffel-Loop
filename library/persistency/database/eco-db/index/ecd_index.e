note
	description: "Index for ${ECD_ARRAYED_LIST [G]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "3"

deferred class
	ECD_INDEX [G -> EL_STORABLE]

feature -- Status query

	has (a_item: G): BOOLEAN
		deferred
		end

feature -- Event handlers

	on_delete (a_item: G)
		deferred
		end

	on_extend (a_item: G)
		deferred
		end

	on_replace (old_item, new_item: G)
		deferred
		end

	wipe_out
		deferred
		end

end
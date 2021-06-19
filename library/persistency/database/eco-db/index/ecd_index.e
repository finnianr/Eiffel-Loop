note
	description: "Index for [$source ECD_ARRAYED_LIST [G]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-19 11:07:32 GMT (Saturday 19th June 2021)"
	revision: "1"

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
note
	description: "Storable arrayed list of ${STORABLE_STRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 8:22:47 GMT (Thursday 11th July 2024)"
	revision: "11"

class
	STORABLE_STRING_LIST

inherit
	ECD_STORABLE_CHAIN [STORABLE_STRING]
		rename
			on_delete as do_nothing
		end

	ARRAYED_LIST [STORABLE_STRING]
		rename
			make as make_chain_implementation,
			append as append_sequence
		end

feature {NONE} -- Implementation

	new_item: like item
		do
			create Result.make_empty
		end

	software_version: NATURAL
		-- Format of application version.
		do
		end

end
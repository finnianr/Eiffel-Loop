note
	description: "Storable string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-29 11:26:29 GMT (Sunday 29th December 2019)"
	revision: "6"

class
	STORABLE_STRING_LIST

inherit
	ECD_CHAIN [STORABLE_STRING]
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

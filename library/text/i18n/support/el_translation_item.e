note
	description: "Translated item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-29 7:46:19 GMT (Wednesday 29th November 2017)"
	revision: "2"

class
	EL_TRANSLATION_ITEM

inherit
	EL_STORABLE
		rename
			read_version as read_default_version
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_key: like key; a_text: like text)
		do
			key := a_key; text := a_text
		end

feature -- Access

	key: ZSTRING

	text: ZSTRING

feature {NONE} -- Constants

	Field_hash_checksum: NATURAL = 2733220845

end

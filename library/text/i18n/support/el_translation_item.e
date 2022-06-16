note
	description: "Translated item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 10:46:37 GMT (Thursday 16th June 2022)"
	revision: "7"

class
	EL_TRANSLATION_ITEM

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			read_version as read_default_version
		end

	EL_ZSTRING_CONSTANTS

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

	field_hash: NATURAL = 83750057

end
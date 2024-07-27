note
	description: "[
		Translated storable item. Lookup keys may have an optional language prefix, `"en."' for example.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-27 14:41:06 GMT (Saturday 27th July 2024)"
	revision: "10"

class
	EL_TRANSLATION_ITEM

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			foreign_naming as eiffel_naming,
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

feature -- Status query

	has_language: BOOLEAN
		do
			Result := key.index_of ('.', 1) = 3
		end

feature -- Access

	key: ZSTRING

	language: STRING
		require
			has_language: has_language
		do
			Result := key.substring_to ('.')
			if Result.count /= 2 then
				Result.wipe_out
			end
		end

	text: ZSTRING

feature -- Element change

	remove_language
		-- remove language prefix
		do
			key.remove_head (3)
		end

feature {NONE} -- Constants

	field_hash: NATURAL = 83750057

end
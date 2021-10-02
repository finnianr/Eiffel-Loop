note
	description: "[
		Cache table of localized currencies accessible via [$source EL_SHARED_LOCALIZED_CURRENCY_TABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-02 15:19:37 GMT (Saturday 2nd October 2021)"
	revision: "1"

class
	EL_LOCALIZED_CURRENCY_TABLE

inherit
	EL_CACHE_TABLE [EL_CURRENCY, STRING]
		rename
			make as make_cache,
			item as currency_item
		export
			{NONE} all
		end

	EL_SHARED_CURRENCY_ENUM

create
	make

feature {NONE} -- Initialization

	make
		do
			create key_buffer
			make_cache (Currency_enum.list.count, agent new_currency)
		end

feature -- Access

	item (language: STRING; code: NATURAL_8): EL_CURRENCY
		local
			key: STRING
		do
			key := key_buffer.copied (language)
			key.append_character ('-')
			key.append_integer (code)
			Result := currency_item (key)
		end

feature {NONE} -- Implementation

	new_currency (key: STRING): EL_CURRENCY
		require
			has_hypen: key.occurrences ('-') = 1
		local
			s: EL_STRING_8_ROUTINES; code: STRING
		do
			code := s.substring_to_reversed (key, '-', Default_pointer)
			create Result.make (s.substring_to (key, '-', Default_pointer), code.to_natural_8)
		end

feature {NONE} -- Internal attributes

	key_buffer: EL_STRING_8_BUFFER

end
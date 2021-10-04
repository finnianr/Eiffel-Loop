note
	description: "[
		Cache table of localized currencies accessible via [$source EL_SHARED_LOCALIZED_CURRENCY_TABLE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-04 10:41:04 GMT (Monday 4th October 2021)"
	revision: "2"

class
	EL_LOCALIZED_CURRENCY_TABLE

inherit
	EL_FUNCTION_CACHE_TABLE [EL_CURRENCY, TUPLE [language: STRING; code: NATURAL_8]]
		rename
			make as make_cache,
			item as cached_item
		export
			{NONE} all
		end

	EL_SHARED_CURRENCY_ENUM

create
	make

feature {NONE} -- Initialization

	make
		do
			make_cache (Currency_enum.list.count, agent new_currency)
		end

feature -- Access

	item (language: STRING; code: NATURAL_8): EL_CURRENCY
		do
			if attached argument_key as key then
				key.language := language
				key.code := code
				Result := cached_item (key)
			end
		end

feature {NONE} -- Implementation

	new_currency (language: STRING; code: NATURAL_8): EL_CURRENCY
		do
			create Result.make (language, code)
		end

end
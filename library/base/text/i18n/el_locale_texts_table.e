note
	description: "[
		Table of items conforming to [$source EL_REFLECTIVE_LOCALE_TEXTS] 
		for each language in `Locale.all_languages'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 10:40:16 GMT (Monday 25th December 2023)"
	revision: "7"

class
	EL_LOCALE_TEXTS_TABLE [TEXTS -> EL_REFLECTIVE_LOCALE_TEXTS create make, make_with_locale end]

inherit
	EL_CACHE_TABLE [TEXTS, STRING]
		rename
			make as make_table,
			new_item as new_texts,
			item as item_text
		export
			{NONE} all
			{ANY} item_text
		end

	EL_MODULE_DEFERRED_LOCALE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_table (Locale.all_languages.count)
		end

feature {NONE} -- Implementation

	new_texts (language: STRING): TEXTS
		do
			if Locale.has_language (language) then
				create Result.make_with_locale (Locale.in (language))
			else
				create Result.make
			end
		end
end
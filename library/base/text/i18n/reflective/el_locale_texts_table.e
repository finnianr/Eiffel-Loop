note
	description: "[
		Table of items conforming to ${EL_REFLECTIVE_LOCALE_TEXTS} 
		for each language in `Locale.all_languages'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:32:45 GMT (Tuesday 20th August 2024)"
	revision: "9"

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
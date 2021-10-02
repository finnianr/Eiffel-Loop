note
	description: "[
		Table of items conforming to [$source EL_REFLECTIVE_LOCALE_TEXTS] 
		for each language in `Locale.all_languages'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-27 15:35:24 GMT (Monday 27th September 2021)"
	revision: "4"

class
	EL_LOCALE_TEXTS_TABLE [TEXTS -> EL_REFLECTIVE_LOCALE_TEXTS create make, make_with_locale end]

inherit
	EL_CACHE_TABLE [TEXTS, STRING]
		rename
			make as make_cached,
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
			make_cached (Locale.all_languages.count, agent new_texts)
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
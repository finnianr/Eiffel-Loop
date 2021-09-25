note
	description: "[
		Table of items conforming to [$source EL_REFLECTIVE_LOCALE_TEXTS] 
		for each language in `Locale.all_languages'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-25 11:48:35 GMT (Saturday 25th September 2021)"
	revision: "1"

class
	EL_LOCALE_TEXTS_TABLE [TEXTS -> EL_REFLECTIVE_LOCALE_TEXTS create make, make_with_locale end]

inherit
	HASH_TABLE [TEXTS, STRING]
		rename
			make as make_with_count
		export
			{NONE} all
			{ANY} found_item, item, has_key
		end

	EL_MODULE_DEFERRED_LOCALE

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_count (Locale.all_languages.count)
			create default_text.make
			across Locale.all_languages as language loop
				if language.item ~ Locale.default_language then
					put (default_text, language.item)
				else
					put (create {TEXTS}.make_with_locale (Locale.in (language.item)), language.item)
				end
			end
		end

feature -- Access

	default_text: TEXTS

end
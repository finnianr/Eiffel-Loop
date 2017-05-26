note
	description: "[
		Object available via `{EL_MODULE_DEFERRED_LOCALE}.locale' that deferrs localization implementation
		until the function `{EL_MODULE_DEFERRED_LOCALE}.new_locale' is over-ridden to return `EL_LOCAL_I'.
		See class `EL_MODULE_LOCALE' in library `i18n.ecf'. The intention is to prevent circular library dependencies.
		
		By default `translation' returns the key as a `ZSTRING'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-25 12:29:05 GMT (Thursday 25th May 2017)"
	revision: "1"

deferred class
	EL_DEFERRED_LOCALE_I

inherit
	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		end

	EL_SHARED_ONCE_STRINGS

	EL_STRING_CONSTANTS

feature -- Access

	translation alias "*" (key: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := translated_string (translations, key)
		end

	translation_array (keys: INDEXABLE [READABLE_STRING_GENERAL, INTEGER]): ARRAY [ZSTRING]
			--
		local
			i, upper, lower: INTEGER
		do
			lower := keys.lower; upper := keys.upper
			create Result.make_filled (Empty_string, 1, upper - lower + 1)
			from i := lower until i > upper loop
				Result [i - lower + 1] := translated_string (translations, keys [i])
				i := i + 1
			end
		end

feature {EL_MODULE_DEFERRED_LOCALE} -- Element change

	set_next_translation (text: READABLE_STRING_GENERAL)
		-- set text to return on next call to `translation' with key enclosed with curly braces "{}"
		deferred
		end

feature {NONE} -- Implementation

	translated_string (table: like translations; key: READABLE_STRING_GENERAL): ZSTRING
		deferred
		end

	translations: EL_ZSTRING_HASH_TABLE [ZSTRING]
		deferred
		end

end

note
	description: "[
		Object available via `{[$source EL_MODULE_DEFERRED_LOCALE]}.Locale' that allows strings in descendants of
		[$source EL_MODULE_DEFERRED_LOCALE] to be optionally localized at an application level by including class
		[$source EL_MODULE_LOCALE] from the `i18n.ecf' library. By default `translation' returns the key as a `ZSTRING'
		
		Localized strings are referred to using the shorthand syntax:
		
			Locale * "<text>"		
		
		Originally this class was introduced to prevent circular library dependencies.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:07:07 GMT (Wednesday 21st February 2018)"
	revision: "5"

deferred class
	EL_DEFERRED_LOCALE_I

inherit
	EL_ZSTRING_ROUTINES
		export
			{NONE} all
		end

	EL_STRING_CONSTANTS

feature -- Access

	date_text: EL_DATE_TEXT
		deferred
		end

	in (a_language: STRING): EL_DEFERRED_LOCALE_I
		deferred
		end

	translation alias "*" (key: READABLE_STRING_GENERAL): ZSTRING
			-- by default returns `key' as a `ZSTRING' unless localization is enabled at an
			-- application level
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

	translation_keys: ARRAY [ZSTRING]
		deferred
		end

feature {EL_MODULE_DEFERRED_LOCALE, EL_DATE_TEXT} -- Element change

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

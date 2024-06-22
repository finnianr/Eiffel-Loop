note
	description: "[
		Object available via ${EL_MODULE_DEFERRED_LOCALE}.Locale that allows strings in descendants of
		${EL_MODULE_DEFERRED_LOCALE} to be optionally localized at an application level by including class
		${EL_MODULE_LOCALE} from the `i18n.ecf' library. By default `translation' returns the key as a `ZSTRING'
		
		Localized strings are referred to using the shorthand syntax:
		
			Locale * "<text>"		
		
		Originally this class was introduced to prevent circular library dependencies.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-22 5:26:20 GMT (Saturday 22nd June 2024)"
	revision: "29"

deferred class
	EL_DEFERRED_LOCALE_I

inherit
	EL_SOLITARY

	EL_MODULE_TUPLE

	EL_STRING_GENERAL_ROUTINES

	EL_ZSTRING_CONSTANTS; EL_LOCALE_CONSTANTS

	EL_SHARED_FORMAT_FACTORY

feature -- Access

	all_languages: EL_STRING_8_LIST
		deferred
		end

	date_text: EL_DATE_TEXT
		deferred
		end

	default_language: STRING
		deferred
		end

	double_as_string (d: DOUBLE; likeness: STRING): STRING
		deferred
		end

	in (a_language: STRING): EL_DEFERRED_LOCALE_I
		deferred
		end

	language: STRING
		deferred
		end

	quantity_translation (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): ZSTRING
			-- translation with adjustments according to value of quanity
			-- keys have
		require
			valid_key_for_quanity: is_valid_quantity_key (partial_key, quantity)
		do
			Result := quantity_translation_extra (partial_key, quantity, Empty_substitutions)
		end

	quantity_translation_extra (
		partial_key: READABLE_STRING_GENERAL; quantity: INTEGER; substitutions: like Empty_substitutions
	): ZSTRING
			-- translation with adjustments according to value of `quantity'
		require
			valid_key_for_quanity: is_valid_quantity_key (partial_key, quantity)
		local
			template: like translation_template; name: READABLE_STRING_8
		do
			template := translation_template (partial_key, quantity)
			across substitutions as list loop
				name := list.item.name
				if template.has (name) then
					template.put_general (name, list.item.value)
				end
			end
			if template.has (Var_quantity) then
				template.put_general (Var_quantity, quantity.out)
			end
			Result := template.substituted
		end

	translation alias "*" (key: READABLE_STRING_GENERAL): ZSTRING
			-- by default returns `key' as a `ZSTRING' unless localization is enabled at an
			-- application level
		do
			Result := translation_item (key)
		end

	translation_keys: ARRAY [ZSTRING]
		deferred
		end

feature -- Basic operations

	fill_tuple (a_tuple: TUPLE; key_list: READABLE_STRING_GENERAL)
		-- fill ZSTRING tuple with translations corresponding to keys in `key_list'
		require
			zstring_tuple: is_zstring_tuple (a_tuple)
			enough_keys: a_tuple.count = key_list.occurrences (',') + 1
			has_keys: has_keys (key_list)
		local
			comma_split: EL_SPLIT_ZSTRING_ON_CHARACTER
		do
			create comma_split.make_adjusted (as_zstring (key_list), ',', {EL_SIDE}.Left)
			across comma_split as list until list.cursor_index > a_tuple.count loop
				a_tuple.put_reference (translation_item (list.item), list.cursor_index)
			end
		end

feature -- Status query

	is_valid_quantity_key (key: READABLE_STRING_GENERAL; quantity: INTEGER): BOOLEAN
		deferred
		end

	is_zstring_tuple (a_tuple: TUPLE): BOOLEAN
		do
			Result := Tuple.type_array (a_tuple).is_uniformly ({ZSTRING})
		end

	has_language (a_language: STRING): BOOLEAN
		deferred
		end

	has_key (key: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `key' is present
		do
			Result := has_item_key (key)
		end

	has_keys (key_list: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if all keys in comma separated list `key_list' are present
		local
			split_list: EL_ZSTRING_LIST
		do
			create split_list.make_comma_split (key_list)
			Result := across split_list as list all has_item_key (list.item) end
		end

	english_only: BOOLEAN
		-- `True' if application is not localized
		do
			Result := True
		end

	valid_tuple (a_tuple: TUPLE; key_list: READABLE_STRING_GENERAL): BOOLEAN
		do
			if is_zstring_tuple (a_tuple) then
				Result := a_tuple.count = key_list.occurrences (',') + 1 and then has_keys (key_list)
			end
		end

feature {EL_MODULE_DEFERRED_LOCALE, EL_DATE_TEXT} -- Element change

	set_next_translation (text: READABLE_STRING_GENERAL)
		-- set text for next call to `translation' with key enclosed with curly braces "{}"
		deferred
		end

	set_next_quantity_translation (quantity: INTEGER; text: READABLE_STRING_GENERAL)
		-- set text for next call to `quantity_translation_extra' with key enclosed with curly braces "{}"
		require
			valid_quantity: 0 <= quantity and quantity <= 2
		deferred
		end

feature {NONE} -- Implementation

	has_item_key (key: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `key' is present
		deferred
		end

	translation_template (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): EL_TEMPLATE [ZSTRING]
		deferred
		end

	translation_item (key: READABLE_STRING_GENERAL): ZSTRING
		-- translation for `key'
		deferred
		end

end
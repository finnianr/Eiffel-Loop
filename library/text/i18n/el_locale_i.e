note
	description: "[
		Object accessible via `EL_MODULE_LOCALE' that returns translated strings using the syntax:
		
			Locale * "<text>"
			
		The translation files are named `locale.x' where `x' is a 2 letter country code, with
		expected location defined by `Localization_dir', By default this is set to 
		`Directory.Application_installation' accessible via `EL_MODULE_DIRECTORY'.
		
		The locale data files are compiled from Pyxis format using the `el_toolkit -compile_translations'
		sub-application option.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-17 8:57:45 GMT (Thursday 17th August 2017)"
	revision: "6"

deferred class
	EL_LOCALE_I

inherit
	EL_DEFERRED_LOCALE_I
		redefine
			translation, translation_array
		end

	EL_SINGLE_THREAD_ACCESS

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_SHARED_LOCALE_TABLE

	EL_LOCALE_CONSTANTS

feature {NONE} -- Initialization

 	make (a_language: STRING; a_default_language: like default_language)
		do
			make_default
			restrict_access
				default_language := a_default_language
				if Locale_table.has (a_language) then
					language := a_language
				else
					language := default_language
				end
				translations := new_translation_table (language)
				if language ~ "en" then
					create {EL_ENGLISH_DATE_TEXT} date_text.make
				else
					create {EL_LOCALE_DATE_TEXT} date_text.make (Current)
				end
			end_restriction
		end

feature -- Access

	all_languages: ARRAYED_LIST [STRING]
		do
			restrict_access -- synchronized
				create Result.make_from_array (Locale_table.current_keys)
			end_restriction
		end

	date_text: EL_DATE_TEXT

	default_language: STRING

	language: STRING
		-- selected language code with translation, defaults to English if no
		-- translation available
		-- Possible values: en, de, fr..

	quantity_translation (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): ZSTRING
			-- translation with adjustments according to value of quanity
			-- keys have
		require
			valid_key_for_quanity: is_valid_quantity_key (partial_key, quantity)
		local
			substitutions: like translation_template.NAME_VALUE_PAIR_ARRAY
		do
			create substitutions.make_empty
			Result := quantity_translation_extra (partial_key, quantity, substitutions)
		end

	quantity_translation_extra (
		partial_key: READABLE_STRING_GENERAL; quantity: INTEGER
		substitutions: like translation_template.NAME_VALUE_PAIR_ARRAY
	): ZSTRING
			-- translation with adjustments according to value of `quantity'
		require
			valid_key_for_quanity: is_valid_quantity_key (partial_key, quantity)
		local
			template: like translation_template
		do
			restrict_access
				template := translation_template (translations, partial_key, quantity)
			end_restriction

			template.disable_strict
			template.set_variables_from_array (substitutions)
			if template.has_variable (Variable_quantity) then
				template.set_variable (Variable_quantity, quantity)
			end
			Result := template.substituted
		end

  	substituted (template_key: READABLE_STRING_GENERAL; inserts: TUPLE): ZSTRING
  		do
  			Result := translation (template_key).substituted_tuple (inserts)
  		end

	translation alias "*" (key: READABLE_STRING_GENERAL): ZSTRING
			-- translation for source code string in current user language
		do
			restrict_access
				Result := Precursor (key)
			end_restriction
		end

	translation_array (keys: INDEXABLE [READABLE_STRING_GENERAL, INTEGER]): ARRAY [ZSTRING]
			--
		do
			restrict_access -- synchronized
				Result := Precursor (keys)
			end_restriction
		end

	translation_keys: ARRAY [ZSTRING]
		do
			restrict_access -- synchronized
				Result := translations.current_keys
			end_restriction
		end

	user_language_code: STRING
			--
		deferred
		end

feature -- Status report

	has_key (key: READABLE_STRING_GENERAL): BOOLEAN
			-- translation for source code string in current user language
		do
			restrict_access
				Result := translations.has_general (key)
			end_restriction
		end

	has_translation (a_language: STRING): BOOLEAN
		do
			restrict_access -- synchronized
				Result := Locale_table.has (a_language)
			end_restriction
		end

	is_valid_quantity_key (key: READABLE_STRING_GENERAL; quantity: INTEGER): BOOLEAN
		do
			restrict_access
				Result := translations.has_general_quantity_key (key, quantity)
			end_restriction
		end

feature {NONE} -- Implementation

	in (a_language: STRING): EL_LOCALE_I
		do
			Result := Current
		end

	set_next_translation (text: READABLE_STRING_GENERAL)
		-- not used
		do
		end

	translated_string (table: like translations; a_key: READABLE_STRING_GENERAL): ZSTRING
		do
			table.search_general (a_key)
			if table.found then
				Result := table.found_item
			else
				Result := Unknown_key_template #$ [a_key]
			end
		end

	translation_template (
		table: like translations; partial_key: READABLE_STRING_GENERAL; quantity: INTEGER
	): EL_SUBSTITUTION_TEMPLATE [ZSTRING]
		do
			table.search_quantity_general (partial_key, quantity)
			if table.found then
				Result := table.found_item
			else
				Result := Unknown_quantity_key_template #$ [partial_key, quantity]
			end
		end

feature {NONE} -- Internal attributes

	translations: EL_TRANSLATION_TABLE

end

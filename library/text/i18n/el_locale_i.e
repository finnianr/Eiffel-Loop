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
	date: "2017-05-27 5:29:18 GMT (Saturday 27th May 2017)"
	revision: "5"

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

	EL_SHARED_ONCE_STRINGS

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

	date_text: EL_DATE_TEXT

	translation alias "*" (key: READABLE_STRING_GENERAL): ZSTRING
			-- translation for source code string in current user language
		do
			restrict_access
				Result := Precursor (key)
			end_restriction
		end

	quantity_translation (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): ZSTRING
			-- translation with adjustments according to value of quanity
			-- keys have
		require
			valid_key_for_quanity: is_valid_quantity_key (partial_key, quantity)
		local
			substitutions: ARRAY [like translation_template.Type_name_value_pair]
		do
			create substitutions.make_empty
			Result := quantity_translation_extra (partial_key, quantity, substitutions)
		end

	quantity_translation_extra (
		partial_key: READABLE_STRING_GENERAL; quantity: INTEGER
		substitutions: ARRAY [like translation_template.Type_name_value_pair]
	): ZSTRING
			-- translation with adjustments according to value of quanity
		require
			valid_key_for_quanity: is_valid_quantity_key (partial_key, quantity)
		local
			template: like translation_template
		do
			restrict_access
				template := translation_template (quantity_key (partial_key, quantity))
				template.disable_strict
				template.set_variables_from_array (substitutions)
				if template.has_variable (Variable_quantity) then
					template.set_variable (Variable_quantity, quantity)
				end
				Result := template.substituted
			end_restriction
		end

  	substituted (template_key: READABLE_STRING_GENERAL; inserts: TUPLE): ZSTRING
  		do
  			Result := translation (template_key).substituted_tuple (inserts)
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

	default_language: STRING

	language: STRING
		-- selected language code with translation, defaults to English if no
		-- translation available
		-- Possible values: en, de, fr..

	all_languages: ARRAYED_LIST [STRING]
		do
			restrict_access -- synchronized
				create Result.make_from_array (Locale_table.current_keys)
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
				Result := translations.has (quantity_key (key, quantity))
			end_restriction
		end

feature {NONE} -- Implementation

	quantity_key (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): ZSTRING
			-- complete partial_key by appending .zero .singular OR .plural
		do
			Result := empty_once_string
			Result.append_string_general (partial_key)
			if quantity = 1 then
				Result.append_string (Dot_singular)
			else
				if quantity = 0 then
					Result.append_string (Dot_zero)
					if not translations.has (Result) then
						Result.remove_tail (Dot_zero.count)
						Result.append_string (Dot_plural)
					end
				else
					Result.append_string (Dot_plural)
				end
			end
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
				create Result.make_from_general (a_key)
				Result.append_character ('*')
			end
		end

	translation_template (a_key: ZSTRING): EL_SUBSTITUTION_TEMPLATE [ZSTRING]
		do
			Result := translated_string (translations, a_key)
		end

	translations: EL_TRANSLATION_TABLE

end

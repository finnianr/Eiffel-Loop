note
	description: "[
		Object accessible via [$source EL_MODULE_LOCALE] that returns translated strings using the syntax:
		
			Locale * "<text>"
			
		The translation files are named `locale.x' where `x' is a 2 letter country code, with
		expected location defined by `Localization_dir', By default this is set to 
		`Directory.Application_installation' accessible via [$source EL_MODULE_DIRECTORY].
		
		The locale data files are compiled from Pyxis format using the `el_toolkit -compile_translations'
		sub-application option.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-28 12:16:20 GMT (Thursday 28th October 2021)"
	revision: "27"

deferred class
	EL_LOCALE_I

inherit
	EL_DEFERRED_LOCALE_I
		redefine
			english_only, has_key, has_keys, fill_tuple, translation
		end

	EL_SINGLE_THREAD_ACCESS
		rename
			make_default as make_access
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_SHARED_SINGLETONS

feature {NONE} -- Initialization

 	make (a_language: STRING; a_default_language: like default_language)
 		require
 			locale_table_created: Singleton_table.has_type ({EL_LOCALE_TABLE}, False)
		do
 			make_solitary; make_access

			restrict_access
				create converter.make

				default_language := a_default_language
				if Locale_table.has (a_language) then
					language := a_language
				else
					language := default_language
				end
				translation_table := new_translation_table (language)
				create date_text.make (Current)
			end_restriction
		end

feature -- Access

	all_languages: EL_STRING_8_LIST
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

  	substituted (template_key: READABLE_STRING_GENERAL; inserts: TUPLE): ZSTRING
  		do
  			Result := translation (template_key).substituted_tuple (inserts)
  		end

	translation alias "*" (key: READABLE_STRING_GENERAL): ZSTRING
			-- translation for source code string in current user language
		do
			restrict_access
				Result := translation_item (key)
			end_restriction
		end

	translation_keys: ARRAY [ZSTRING]
		do
			restrict_access -- synchronized
				Result := translation_table.current_keys
			end_restriction
		end

	user_language_code: STRING
			--
		deferred
		end

feature -- Status query

	english_only: BOOLEAN
		do
			Result := False
		end

	has_all_keys (key_list: ITERABLE [READABLE_STRING_GENERAL]): BOOLEAN
		do
			restrict_access
				Result := across key_list as key all translation_table.has (z_key (key.item)) end
			end_restriction
		end

	has_key (key: READABLE_STRING_GENERAL): BOOLEAN
			-- translation for source code string in current user language
		do
			restrict_access
				Result := has_item_key (key)
			end_restriction
		end

	has_keys (key_list: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if all keys in comma separated list `key_list' are present
		do
			if is_restricted then
				Result := Precursor (key_list)
			else
				restrict_access
					Result := Precursor (key_list)
				end_restriction
			end
		end

	has_language (a_language: STRING): BOOLEAN
		do
			restrict_access -- synchronized
				Result := Locale_table.has (a_language)
			end_restriction
		end

	has_quantity_keys (key_list: ITERABLE [READABLE_STRING_GENERAL]; quantity_lower, quantity_upper: INTEGER): BOOLEAN
		-- `True' if there is a quanity translation for all keys in `key_list' and for all quantity types
		require
			less_than_or_equal_to: quantity_lower <= quantity_upper
			valid_quantities: 0 <= quantity_lower and then quantity_upper <= 2
		local
			quantity_range: INTEGER_INTERVAL
		do
			restrict_access
				quantity_range := quantity_lower |..| quantity_upper
				Result := across key_list as key all
					across quantity_range as n all translation_table.has (z_key_for (key.item, n.item)) end
				end
			end_restriction
		end

	has_translation (a_language: STRING): BOOLEAN
		do
			restrict_access -- synchronized
				Result := Locale_table.has (a_language)
			end_restriction
		end

feature -- Basic operations

	fill_tuple (a_tuple: TUPLE; key_list: READABLE_STRING_GENERAL)
		do
			restrict_access
				Precursor (a_tuple, key_list)
			end_restriction
		end

feature -- Contract Support

	all_readable_strings (key_tuple: TUPLE): BOOLEAN
		do
			Result := Tuple.all_readable_strings (key_tuple)
		end

	is_valid_quantity_key (key: READABLE_STRING_GENERAL; quantity: INTEGER): BOOLEAN
		do
			restrict_access
				Result := translation_table.has (z_key_for (key, quantity)) or else translation_table.has (z_key_plural (key))
			end_restriction
		end

	valid_key_tuple (a_tuple: TUPLE): BOOLEAN
		require
			all_readable_strings: all_readable_strings (a_tuple)
		local
			key_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
		do
			create key_list.make_from_tuple (a_tuple)
			Result := has_all_keys (key_list)
		end

	valid_quantity_key_tuple (a_tuple: TUPLE; quantity_lower, quantity_upper: INTEGER): BOOLEAN
		require
			all_readable_strings: all_readable_strings (a_tuple)
		local
			key_list: EL_ARRAYED_LIST [READABLE_STRING_GENERAL]
		do
			create key_list.make_from_tuple (a_tuple)
			Result := has_quantity_keys (key_list, quantity_lower, quantity_upper)
		end

feature {EL_LOCALE_CONSTANTS} -- Factory

	new_translation_table (a_language: STRING): EL_TRANSLATION_TABLE
		local
			items_list: EL_TRANSLATION_ITEMS_LIST
		do
			create items_list.make_from_file (Locale_table [a_language])
			items_list.retrieve
			Result := items_list.to_table (a_language)
		end

feature {NONE} -- Implementation

	has_item_key (key: READABLE_STRING_GENERAL): BOOLEAN
			-- translation for source code string in current user language
		do
			Result := translation_table.has (z_key (key))
		end

	in (a_language: STRING): EL_LOCALE_I
		do
			Result := Current
		end

	set_next_quantity_translation (quantity: INTEGER; text: READABLE_STRING_GENERAL)
		-- used only in `EL_DEFERRED_LOCALE_IMP'
		do
		end

	set_next_translation (text: READABLE_STRING_GENERAL)
		-- used only in `EL_DEFERRED_LOCALE_IMP'
		do
		end

	translation_template (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): EL_TEMPLATE [ZSTRING]
		do
			restrict_access
				if attached translation_table as table then
					if table.has_key (z_key_for (partial_key, quantity)) then
						create Result.make (table.found_item)

					elseif table.has_key (z_key_plural (partial_key)) then
						create Result.make (table.found_item)

					else
						create Result.make (Unknown_quantity_key_template #$ [partial_key, quantity])
					end
				end
			end_restriction
		end

	translation_item (key: READABLE_STRING_GENERAL): ZSTRING
		-- translation for `key'
		do
			if attached translation_table as table then
				if table.has_key (z_key (key)) then
					Result := table.found_item
				else
					Result := Unknown_key_template #$ [key]
				end
			end
		end

	z_key (key: READABLE_STRING_GENERAL): ZSTRING
		require
			thread_restricted: is_restricted
		do
			Result := converter.to_zstring (key)
		end

	z_key_for (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): ZSTRING
			-- complete partial_key by appending ":0", ":1" or ":>1"
		require
			thread_restricted: is_restricted
		do
			Result := converter.joined (partial_key, Number_suffix [quantity.min (2)])
		end

	z_key_plural (partial_key: READABLE_STRING_GENERAL): ZSTRING
		-- plural ZSTRING key
		require
			thread_restricted: is_restricted
		do
			Result := converter.joined (partial_key, Number_suffix [2])
		end

feature {NONE} -- Internal attributes

	converter: EL_ZSTRING_CONVERTER

	translation_table: EL_TRANSLATION_TABLE

feature {EL_LOCALE_CONSTANTS} -- Constants

	Locale_table: EL_LOCALE_TABLE
	 	-- Table of all locale data file paths
	 	once ("PROCESS")
			Result := create {EL_SINGLETON [EL_LOCALE_TABLE]}
	 	end

end
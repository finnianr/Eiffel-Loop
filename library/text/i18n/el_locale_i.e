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
	date: "2021-08-01 14:35:28 GMT (Sunday 1st August 2021)"
	revision: "18"

deferred class
	EL_LOCALE_I

inherit
	EL_DEFERRED_LOCALE_I
		redefine
			translation, translation_array
		end

	EL_SINGLE_THREAD_ACCESS
		rename
			make_default as make_access
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_LOCALE_CONSTANTS

	EL_SHARED_SINGLETONS

feature {NONE} -- Initialization

 	make (a_language: STRING; a_default_language: like default_language)
 		require
 			locale_table_created: Singleton_table.has_type ({EL_LOCALE_TABLE}, False)
		do
 			make_solitary; make_access

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

	paragraph_list (key: READABLE_STRING_GENERAL): EL_ZSTRING_LIST
		-- `translation' lines joined together as paragraphs with
		-- an empty line interpreted as a paragraph delimiter
		local
			lines, sub_list: EL_ZSTRING_LIST
		once
			create lines.make_with_lines (translation (key))

			create Result.make (lines.count_of (agent {ZSTRING}.is_empty) + 1)
			create sub_list.make (lines.count // Result.capacity + 1)
			across lines as l loop
				if not l.item.is_empty then
					sub_list.extend (l.item)
				end
				if l.item.is_empty or l.is_last then
					Result.extend (sub_list.joined (' '))
					sub_list.wipe_out
				end
			end
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

	translation_array (keys: ITERABLE [READABLE_STRING_GENERAL]): ARRAY [ZSTRING]
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

feature -- Status query

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

	translation_template (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): EL_TEMPLATE [ZSTRING]
		do
			restrict_access
				if attached translations as table then
					table.search_quantity_general (partial_key, quantity)
					if table.found then
						create Result.make (table.found_item)
					else
						create Result.make (Unknown_quantity_key_template #$ [partial_key, quantity])
					end
				end
			end_restriction
		end

feature {NONE} -- Internal attributes

	translations: EL_TRANSLATION_TABLE

feature {EL_LOCALE_CONSTANTS} -- Constants

	Locale_table: EL_LOCALE_TABLE
	 	-- Table of all locale data file paths
	 	once ("PROCESS")
			Result := create {EL_SINGLETON [EL_LOCALE_TABLE]}
	 	end

end
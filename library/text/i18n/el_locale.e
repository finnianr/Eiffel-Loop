note
	description: "[
		Object accessible via ${EL_MODULE_LOCALE} that returns translated strings using the syntax:
		
			Locale * "<text>"
			
		The translation files are named `locale.x' where `x' is a 2 letter country code, with
		expected location defined by `Localization_dir', By default this is set to 
		`Directory.Application_installation' accessible via ${EL_MODULE_DIRECTORY}.
		
		The locale data files are compiled from Pyxis format using the `el_toolkit -compile_translations'
		sub-application option.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 9:50:17 GMT (Thursday 18th July 2024)"
	revision: "41"

class
	EL_LOCALE

inherit
	EL_DEFERRED_LOCALE_I
		rename
			make as make_solitary
		redefine
			english_only, has_key, has_keys, fill_tuple, translation
		end

	EL_SINGLE_THREAD_ACCESS
		redefine
			make_default
		end

	EL_LAZY_ATTRIBUTE
		rename
			item as date_text,
			new_item as new_date_text,
			actual_item as actual_date_text
		end

	EL_MODULE_DIRECTORY; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE_SYSTEM; EL_MODULE_PYXIS

	EL_SHARED_SINGLETONS; EL_SHARED_ADHOC_TRANSLATIONS

	EL_SHARED_KEY_LANGUAGE

create
	make, make_with_table

feature {NONE} -- Initialization

	make (a_language: STRING)
		do
			make_with_table (a_language, Void)
		end

	make_with_table (a_language: STRING; a_translation_table: detachable EL_TRANSLATION_TABLE)
		require
			locale_table_created: Singleton_table.has_type ({EL_LOCALE_TABLE})
		do
			make_default
			if attached a_translation_table as table then
				translation_table := table
			else
				translation_table := new_translation_table (a_language)
			end
			if translation_table.has_key (Decimal_point_key)
				and then attached translation_table.found_item as str
				and then str.count = 1
			then
				decimal_point := str [1].to_character_8
			end
		end

	make_default
		do
			Precursor
			make_solitary
			decimal_point := '.'
		end

feature -- Access

	all_languages: EL_STRING_8_LIST
		do
			restrict_access -- synchronized
				create Result.make_from_array (Locale_table.current_keys)
			end_restriction
		end

	default_language: STRING
		do
			Result := Key_language
		end

	double_as_string (d: DOUBLE; likeness: STRING): STRING
		local
			index_dot: INTEGER
		do
			if decimal_point /= '.' then
				index_dot := likeness.last_index_of ('.', likeness.count)
			end
			if index_dot.to_boolean then
				likeness [index_dot] := decimal_point
				if Format.has_double_key (likeness) then
					Result := Format.found_double.formatted (d)
				else
					Result := Format.double (likeness.twin).formatted (d)
				end
				likeness [index_dot] := '.' -- Restore
			else
				Result := Format.double (likeness).formatted (d)
			end
		ensure then
			likeness_unchange: old likeness ~ likeness
		end

	decimal_point: CHARACTER

	language: STRING
		-- selected language code with translation, defaults to English if no
		-- translation available
		-- Possible values: en, de, fr..
		do
			Result := translation_table.language
		end

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
			-- By example: if LANG = "en_UK.utf-8"
			-- then result = "en"
		do
			Result := Execution_environment.language_code
			if Result.is_empty then
				Result := default_language
			end
		end

feature -- Status query

	english_only: BOOLEAN
		do
			Result := False
		end

	has_all_keys (key_list: ITERABLE [READABLE_STRING_GENERAL]): BOOLEAN
		do
			restrict_access
				Result := across key_list as key all translation_table.has_general (key.item) end
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
				if attached translation_table as table then
					Result := table.has (z_key_for (key, quantity)) or else table.has (z_key_plural (key))
				end
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

	new_date_text: EL_DATE_TEXT
		-- this is a lazy attribute because some ad-hoc locales may not have date translations
		do
			create Result.make (Current)
		end

	new_translation_table (a_language: STRING): EL_TRANSLATION_TABLE
		local
			items_list: EL_TRANSLATION_ITEMS_LIST; l_language: STRING
			adhoc_table: EL_TRANSLATION_TABLE
		do
			restrict_access
				if Locale_table.has (a_language) then
					l_language := a_language
				else
					l_language := default_language
				end
				create items_list.make_from_file (Locale_table [l_language])
				Result := items_list.to_table (l_language)
				if attached Adhoc_translation_source_factory.item as factory then
					factory.apply
					if attached factory.last_result as pyxis_source
						and then pyxis_source.starts_with (Pyxis.declaration)
					then
						create adhoc_table.make_from_pyxis_source (l_language, pyxis_source)
						Result.merge (adhoc_table)
					end
				end
			end_restriction
		end

feature {NONE} -- Implementation

	has_item_key (key: READABLE_STRING_GENERAL): BOOLEAN
			-- translation for source code string in current user language
		do
			Result := translation_table.has_general (key)
		end

	in (a_language: STRING): EL_LOCALE
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
				if table.has_general_key (key) then
					Result := table.found_item
				else
					Result := Unknown_key_template #$ [key]
				end
			end
		end

	z_key_for (partial_key: READABLE_STRING_GENERAL; quantity: INTEGER): ZSTRING
			-- complete partial_key by appending ":0", ":1" or ":>1"
		require
			thread_restricted: is_restricted
		do
			Result := Key_buffer.copied_general (partial_key)
			Result.append_string_general (Number_suffix [quantity.min (2)])
		end

	z_key_plural (partial_key: READABLE_STRING_GENERAL): ZSTRING
		-- plural ZSTRING key
		require
			thread_restricted: is_restricted
		do
			Result := Key_buffer.copied_general (partial_key)
			Result.append_string_general (Number_suffix [2])
		end

feature {NONE} -- Internal attributes

	translation_table: EL_TRANSLATION_TABLE

feature {EL_LOCALE_CONSTANTS} -- Constants

	Key_buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

	Locale_table: EL_LOCALE_TABLE
	 	-- Table of all locale data file paths
	 	once ("PROCESS")
			Result := create {EL_SINGLETON [EL_LOCALE_TABLE]}
	 	end

end
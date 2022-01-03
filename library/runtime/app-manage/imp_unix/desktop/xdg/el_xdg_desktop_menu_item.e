note
	description: "XDG desktop menu item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:05 GMT (Monday 3rd January 2022)"
	revision: "9"

deferred class
	EL_XDG_DESKTOP_MENU_ITEM

inherit
	EVOLICITY_SERIALIZEABLE
		redefine
			getter_function_table
		end

	EL_MODULE_DEFERRED_LOCALE

	EL_MODULE_LIO

feature {NONE} -- Initialization

	make (a_item: like item; a_output_dir: DIR_PATH)
			--
		do
			item := a_item; output_dir := a_output_dir
			make_from_file (new_file_path)
		end

feature -- Access

	file_name: ZSTRING
		do
			Result := item.name.translated_general (" ", "-") + "." + file_name_extension
		end

	name: ZSTRING
		do
			Result := item.name
		end

feature -- Status query

	exists: BOOLEAN
		do
			Result := output_path.exists
		end

	is_standard: BOOLEAN
		do
			Result := item.is_standard
		end

feature -- Basic operations

	install
			--
		do
			if not output_path.exists then
				if is_lio_enabled then
					lio.put_path_field ("Creating entry", output_path)
					lio.put_new_line
				end
				serialize
			end
		end

	uninstall
			--
		do
			if output_path.exists then
				if is_lio_enabled then
					lio.put_path_field ("Deleting entry", output_path)
					lio.put_new_line
				end
				File_system.remove_file (output_path)
			end
		end

feature {NONE} -- Implementation

	file_name_extension: STRING
			--
		deferred
		end

	new_locale_table (english: STRING): HASH_TABLE [ZSTRING, STRING]
		local
			languages: LIST [STRING]
		do
			languages := Locale.all_languages
			create Result.make_equal (languages.count)
			across languages as lang loop
				Result [lang.item] := Locale.in (lang.item) * english
			end
		end

feature -- Access

	new_file_path: FILE_PATH
		do
			Result := output_dir + file_name
		end

feature {NONE} -- Internal attributes

	item: EL_DESKTOP_MENU_ITEM

	output_dir: DIR_PATH

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["icon_path", agent: EL_PATH do Result := item.icon_path end],
				["en", agent: STRING do Result := English_key end],
				["localized_comments", agent: like new_locale_table do Result := new_locale_table (item.comment) end],
				["localized_names", agent: like new_locale_table do Result := new_locale_table (item.name) end]
			>>)
		end

feature {NONE} -- Constants

	English_key: STRING = "en"
end


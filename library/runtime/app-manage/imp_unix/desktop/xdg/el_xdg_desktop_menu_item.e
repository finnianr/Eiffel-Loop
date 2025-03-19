note
	description: "XDG desktop menu item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:19 GMT (Tuesday 18th March 2025)"
	revision: "20"

deferred class
	EL_XDG_DESKTOP_MENU_ITEM

inherit
	EVC_SERIALIZEABLE
		rename
			Var as Standard_var
		redefine
			getter_function_table
		end

	EL_MODULE_DEFERRED_LOCALE; EL_MODULE_LIO; EL_MODULE_TUPLE

	EL_CHARACTER_32_CONSTANTS; EL_ZSTRING_CONSTANTS


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
			Result := dot.joined (item.name.translated (space, hyphen), file_name_extension)
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

feature -- Access

	new_file_path: FILE_PATH
		do
			Result := output_dir + file_name
		end

feature {NONE} -- Internal attributes

	item: EL_DESKTOP_MENU_ITEM

	output_dir: DIR_PATH

feature {NONE} -- Evolicity reflection

	get_locale_table: EL_HASH_TABLE [EVC_TUPLE_CONTEXT, STRING]
		local
			context: EVC_TUPLE_CONTEXT; comment: ZSTRING
		do
			create Result.make_equal (Locale.all_languages.count)
			across Locale.all_languages as lang loop
				if item.comment.is_empty then
					comment := Empty_string
				else
					comment := Locale.in (lang.item) * item.comment
				end
				create context.make ([Locale.in (lang.item) * item.name, comment], once "name, comment")

				Result.extend (context, lang.item)
			end
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["icon_path", agent: EL_PATH do Result := item.icon_path end],
				[Eng_code, agent: STRING do Result := Eng_code end],
				["locale_table", agent get_locale_table]
			>>)
		end

feature {NONE} -- Constants

	Eng_code: STRING = "en"
end
note
	description: "XDG desktop menu item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-13 18:03:27 GMT (Sunday 13th March 2022)"
	revision: "11"

deferred class
	EL_XDG_DESKTOP_MENU_ITEM

inherit
	EVOLICITY_SERIALIZEABLE
		redefine
			getter_function_table
		end

	EL_MODULE_DEFERRED_LOCALE; EL_MODULE_LIO; EL_MODULE_TUPLE

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

feature -- Access

	new_file_path: FILE_PATH
		do
			Result := output_dir + file_name
		end

feature {NONE} -- Internal attributes

	item: EL_DESKTOP_MENU_ITEM

	output_dir: DIR_PATH

feature {NONE} -- Evolicity reflection

	get_locale_table: HASH_TABLE [EVOLICITY_CONTEXT_IMP, STRING]
		local
			context: EVOLICITY_CONTEXT_IMP
		do
			create Result.make_equal (Locale.all_languages.count)
			across Locale.all_languages as lang loop
				create context.make
				context.put_string (Var.name, Locale.in (lang.item) * item.name)
				if item.comment.is_empty then
					context.put_string (Var.comment, Empty_string)
				else
					context.put_string (Var.comment, Locale.in (lang.item) * item.comment)
				end
				Result.extend (context, lang.item)
			end
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["icon_path", agent: EL_PATH do Result := item.icon_path end],
				[Eng_code, agent: STRING do Result := Eng_code end],
				["locale_table", agent get_locale_table]
			>>)
		end

feature {NONE} -- Constants

	Var: TUPLE [name, comment: STRING]
		once
			create Result
			Tuple.fill (Result, "name, comment")
		end

	Eng_code: STRING = "en"
end
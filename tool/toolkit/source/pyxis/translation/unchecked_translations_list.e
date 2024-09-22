note
	description: "Unchecked translations list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 16:42:50 GMT (Sunday 22nd September 2024)"
	revision: "12"

class
	UNCHECKED_TRANSLATIONS_LIST

inherit
	EL_ZSTRING_LIST
		rename
			make as make_with_count,
			put as put_list
		end

	EL_BUILDABLE_FROM_PYXIS
		undefine
			is_equal, copy, default_create
		redefine
			make_default, building_action_table
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (a_language: STRING; a_file_path: FILE_PATH)
		do
			language := a_language; file_path := a_file_path
			make_from_file (a_file_path)
		end

	make_default
		do
			create last_id.make_empty
			make_with_count (11)
			Precursor
		end

feature -- Access

	language: STRING

	file_path: FILE_PATH

feature {NONE} -- Implementation

	try_extend (is_checked: BOOLEAN)
		do
			if not is_checked then
				extend (last_id)
			end
		end

	translation_check_xpath: STRING
		local
			template: ZSTRING
		do
			template := "item/translation[@lang='%S']/@check"
			Result := template #$ [language]
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make_assignments (<<
				["item/@id",					agent do last_id := node end],
				[translation_check_xpath,	agent do try_extend (node) end]
			>>)
		end

feature {NONE} -- Internal attributes

	last_id: ZSTRING

feature {NONE} -- Constants

	Root_node_name: STRING = "translations"

end
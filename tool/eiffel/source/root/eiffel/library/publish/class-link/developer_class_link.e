note
	description: "Link to published class created by developer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-22 10:27:23 GMT (Monday 22nd January 2024)"
	revision: "1"

class
	DEVELOPER_CLASS_LINK

inherit
	CLASS_LINK
		redefine
			adjusted_path, github_markup, is_valid, wiki_markup
		end

	EL_CHARACTER_32_CONSTANTS

create
	make

feature -- Status query

	is_valid: BOOLEAN = True

feature -- Access

	adjusted_path (relative_page_dir: DIR_PATH): FILE_PATH
		do
			Result := path.universal_relative_path (relative_page_dir)
		end

	github_markup (repository_web_address: ZSTRING): ZSTRING
		local
			l_path: ZSTRING
		do
			l_path := char ('/').joined (repository_web_address, path.to_string)
			Result := Github_link_template #$ [path, type_name]
		end

	wiki_markup (web_address: ZSTRING): ZSTRING
		do
			Result := Wiki_link_template #$ [web_address, path, type_name]
		end

feature {NONE} -- Constants

	Wiki_link_template: ZSTRING
		once
			Result := "[%S/%S %S]"
		end
end
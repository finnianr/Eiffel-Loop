note
	description: "Link to published documentation page of class created by developer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-22 18:14:19 GMT (Monday 22nd January 2024)"
	revision: "4"

class
	DEVELOPER_CLASS_LINK

inherit
	CLASS_LINK
		redefine
			adjusted_path, github_markdown, is_valid, wiki_markup
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

	github_markdown (github_url: EL_DIR_URI_PATH): ZSTRING
		do
			Result := Github_link_template #$ [type_name, github_url + path]
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
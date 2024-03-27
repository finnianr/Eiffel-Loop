note
	description: "Link to published documentation page of class created by developer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-27 7:34:26 GMT (Wednesday 27th March 2024)"
	revision: "7"

class
	DEVELOPER_CLASS_LINK

inherit
	CLASS_LINK
		redefine
			adjust_path, github_markdown, is_valid, wiki_markup
		end

create
	make

feature -- Status query

	is_valid: BOOLEAN = True

feature -- Access

	github_markdown (github_url: EL_DIR_URI_PATH): ZSTRING
		local
			index_left, index_right: INTEGER
		do
			Result := Github_link_template #$ [type_name, github_url + path]
		-- Change .html to .e
			index_right := Result.count - 1
			index_left := index_right - 3
			if Result.valid_index (index_left) then
				Result.replace_substring (char ('e'), index_left, index_right)
			end
		end

	wiki_markup (web_address: ZSTRING): ZSTRING
		do
			Result := Wiki_link_template #$ [web_address, path.to_unix, type_name]
		end

feature -- Element change

	adjust_path (relative_page_dir: DIR_PATH)
		do
			path := path.universal_relative_path (relative_page_dir)
		end

feature {NONE} -- Constants

	Wiki_link_template: ZSTRING
		once
			Result := "[%S/%S %S]"
		end
end
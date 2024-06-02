note
	description: "Link to published documentation page of class created by developer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-01 10:33:38 GMT (Saturday 1st June 2024)"
	revision: "10"

class
	DEVELOPER_CLASS_LINK

inherit
	CLASS_LINK
		rename
			make as make_link
		redefine
			github_markdown, relative_path, wiki_markup
		end

create
	make

feature {NONE} -- Initialization

	make (a_class: EIFFEL_CLASS; a_class_name: ZSTRING; a_type: NATURAL_8)
		do
			make_link (a_class_name, a_type)
			eiffel_class := a_class
		end

feature -- Access

	github_markdown (github_url: EL_DIR_URI_PATH): ZSTRING
		local
			index_left, index_right: INTEGER
		do
			Result := Github_link_template #$ [class_name, github_url + path]
		-- Change .html to .e
			index_right := Result.count - 1
			index_left := index_right - 3
			if Result.valid_index (index_left) then
				Result.replace_substring (char ('e'), index_left, index_right)
			end
		end

	path: FILE_PATH
		do
			if attached eiffel_class as e_class then
				Result := e_class.relative_html_path
			else
				create Result
			end
		end

	relative_path (relative_page_dir: DIR_PATH): FILE_PATH
		do
			Result := path.universal_relative_path (relative_page_dir)
		end

	wiki_markup (web_address: ZSTRING): ZSTRING
		do
			Result := Wiki_link_template #$ [web_address, path.to_unix, class_name]
		end

feature {NONE} -- Constants

	Wiki_link_template: ZSTRING
		once
			Result := "[%S/%S %S]"
		end

end
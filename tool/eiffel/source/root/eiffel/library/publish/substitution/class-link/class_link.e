note
	description: "HTML link to Eiffel class documentation page (invalid by default)"
	descendants: "[
			CLASS_LINK
				${ISE_CLASS_LINK}
				${DEVELOPER_CLASS_LINK}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-30 15:38:04 GMT (Saturday 30th March 2024)"
	revision: "7"

class
	CLASS_LINK

inherit
	ANY

	PUBLISHER_CONSTANTS

	EL_ZSTRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_path: FILE_PATH; a_class_name: ZSTRING)
		do
			path := a_path; class_name := a_class_name
			expanded_parameters := Empty_string
		end

feature -- Status query

	is_valid: BOOLEAN
		-- `True' in descendants
		do
			Result := False
		end

	has_parameters: BOOLEAN
		do
			Result := expanded_parameters /= Empty_string
		end

feature -- Access

	relative_path (relative_page_dir: DIR_PATH): FILE_PATH
		do
			Result := path
		end

	class_name: ZSTRING

	expanded_parameters: ZSTRING

	path: FILE_PATH

feature -- Measurement

	path_count: INTEGER
		do
			Result := path.count
		end

feature -- Markup

	github_markdown (github_url: EL_DIR_URI_PATH): ZSTRING
		do
			Result := Github_link_template #$ [class_name, path]
		end

	wiki_markup (web_address: ZSTRING): ZSTRING
		do
			Result := class_name
		end

feature -- Code substring indices

	end_index: INTEGER
		-- index of "}"

	start_index: INTEGER
		-- index of "${"

feature -- Element change

	adjust_path (relative_page_dir: DIR_PATH)
		do
		end

	set_end_index (a_end_index: INTEGER)
		do
			end_index := a_end_index
		end

	set_expanded_parameters (a_expanded_parameters: ZSTRING)
		do
			expanded_parameters := a_expanded_parameters
		end

	set_start_index (a_start_index: INTEGER)
		do
			start_index := a_start_index
		end

end
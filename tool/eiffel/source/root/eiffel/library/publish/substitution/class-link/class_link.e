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
	date: "2024-03-27 14:51:46 GMT (Wednesday 27th March 2024)"
	revision: "5"

class
	CLASS_LINK

inherit
	ANY

	PUBLISHER_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_path: FILE_PATH; a_code_text: ZSTRING; a_start_index, a_end_index: INTEGER)
		require
			valid_start_index: a_code_text.valid_index (a_start_index + 1)
				and then a_code_text.substring (a_start_index, a_start_index + 1) ~ Dollor_left_brace

			valid_end_index: a_code_text.valid_index (a_end_index) and then a_code_text [a_end_index] = '}'
		do
			path := a_path; code_text := a_code_text
			start_index := a_start_index; end_index := a_end_index
		end

feature -- Status query

	is_valid: BOOLEAN
		-- `True' in descendants
		do
			Result := False
		end

feature -- Access

	class_name: ZSTRING
		local
			bracket_index: INTEGER
		do
			Result := type_name
			bracket_index := Result.index_of ('[', 1)
			if bracket_index > 0 then
				-- remove class parameter
				Result.keep_head (bracket_index - 1)
				Result.right_adjust
			end
		end

	path: FILE_PATH

	reference_marker: ZSTRING
		-- Eg. ${MY_CLASS}
		do
			Result := code_text.substring (start_index, end_index)
		end

	type_name: ZSTRING
		do
			Result := code_text.substring (start_index + 2, end_index - 1)
		end

feature -- Measurement

	path_count: INTEGER
		do
			Result := path.count
		end

feature -- Markup

	github_markdown (github_url: EL_DIR_URI_PATH): ZSTRING
		do
			Result := Github_link_template #$ [type_name, path]
		end

	wiki_markup (web_address: ZSTRING): ZSTRING
		do
			Result := reference_marker
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

feature {NONE} -- Internal attributes

	code_text: ZSTRING

end
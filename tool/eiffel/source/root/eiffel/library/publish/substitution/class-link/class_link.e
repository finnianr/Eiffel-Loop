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
	date: "2024-03-28 13:39:44 GMT (Thursday 28th March 2024)"
	revision: "6"

class
	CLASS_LINK

inherit
	ANY

	PUBLISHER_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_path: FILE_PATH; a_code_text: ZSTRING; class_link_intervals: CLASS_LINK_OCCURRENCE_INTERVALS)
		require
			valid_item: not class_link_intervals.off and then class_link_intervals.valid_item (a_code_text)
		do
			path := a_path; code_text := a_code_text
			start_index := class_link_intervals.item_lower; end_index := class_link_intervals.item_upper
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
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
	date: "2024-06-01 10:55:03 GMT (Saturday 1st June 2024)"
	revision: "10"

deferred class
	CLASS_LINK

inherit
	ANY

	PUBLISHER_CONSTANTS

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Initialization

	make (a_class_name: ZSTRING; a_type: NATURAL_8)
		do
			class_name := a_class_name.twin; type := a_type
			expanded_parameters := Empty_string; routine_name := Empty_string
		end

feature -- Status query

	has_parameters: BOOLEAN
		do
			Result := expanded_parameters /= Empty_string
		end

	is_valid: BOOLEAN
		-- `False' in descendant `INVALID_CLASS_LINK'
		do
			Result := True
		end

feature -- Access

	class_name: ZSTRING

	eiffel_class: detachable EIFFEL_CLASS
		-- developer class or else `Void' if ISE or invalid class

	expanded_parameters: ZSTRING

	relative_path (relative_page_dir: DIR_PATH): FILE_PATH
		do
			Result := path
		end

	routine_name: ZSTRING

	type: NATURAL_8

feature -- Deferred

	path: FILE_PATH
		deferred
		end

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

	set_eiffel_class (a_eiffel_class: EIFFEL_CLASS)
		do
			eiffel_class := a_eiffel_class
		end

	set_end_index (a_end_index: INTEGER)
		do
			end_index := a_end_index
		end

	set_expanded_parameters (a_expanded_parameters: ZSTRING)
		do
			expanded_parameters := a_expanded_parameters
		end

	set_routine_name (a_routine_name: ZSTRING)
		do
			routine_name := a_routine_name
		end

	set_start_index (a_start_index: INTEGER)
		do
			start_index := a_start_index
		end

end
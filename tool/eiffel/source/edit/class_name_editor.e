note
	description: "Class name editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-02 10:45:24 GMT (Sunday 2nd January 2022)"
	revision: "7"

class
	CLASS_NAME_EDITOR

inherit
	EL_PATTERN_SEARCHING_EIFFEL_SOURCE_EDITOR
		rename
			class_name as class_name_pattern
		redefine
			reset
		end

	EL_MODULE_LIO

feature {NONE} -- Initialization

	make
			--
		do
			create class_name.make_empty
			make_default
		end

feature {NONE} -- Pattern definitions

	search_patterns: ARRAYED_LIST [EL_TEXT_PATTERN]
		do
			create Result.make_from_array (<<
				all_of (<<
					all_of (<< white_space, string_literal ("class"), white_space >>) |to| agent on_unmatched_text,
					class_name_pattern |to| agent on_class_name
				>>),
				class_name_pattern |to| agent on_class_reference
			>>)
		end

feature {NONE} -- Implementation

	reset
		do
			Precursor
			class_name.wipe_out
		end

	set_class_name (a_class_name: like class_name)
		require
			class_name_not_empty: not a_class_name.is_empty
		local
			current_class_name: ZSTRING
		do
			class_name := a_class_name.twin
			current_class_name := file_path.base_sans_extension.as_upper
			if current_class_name /~ a_class_name then
				if attached {FILE} output as output_file then
					file_path.set_base (a_class_name.as_lower + ".e")
					output_file.rename_file (file_path)
					lio.put_new_line
					lio.put_labeled_substitution ("Renamed", "%S -> %S", [current_class_name, a_class_name])
					lio.put_new_line
				end
			end
		end

	class_name: ZSTRING

feature {NONE} -- Events

	on_class_name (text: EL_STRING_VIEW)
			--
		do
			if class_name.is_empty then
				class_name := text
			end
			put_string (text)
		end

	on_class_reference (text: EL_STRING_VIEW)
			--
		do
			put_string (text)
		end

end
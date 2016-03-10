note
	description: "Summary description for {EIFFEL_CLASS_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-21 11:19:40 GMT (Thursday 21st January 2016)"
	revision: "5"

class
	EIFFEL_CLASS_EDITOR

inherit
	EIFFEL_SOURCE_EDITING_PROCESSOR
		redefine
			edit
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create new_attribute_name.make_empty
			create insertion_marker_list.make (10)
		end

feature -- Basic operations

	edit
			--
		local
			insertion_editor: EIFFEL_ATTRIBUTE_INSERTION_CLASS_EDITOR
		do
			Precursor

			create insertion_editor.make (insertion_marker_list, new_attribute_name, new_attribute_type)
			insertion_editor.set_input_file_path (source_file_path)
			insertion_editor.set_output_file_path (source_file_path)
			insertion_editor.edit
		end

feature {NONE} -- Pattern definitions

	search_patterns: ARRAYED_LIST [EL_TEXT_PATTERN]
		do
			create Result.make_from_array (<<
				feature_header,
				all_of (<<
					start_of_line,
					string_literal ("end"),
					maybe_non_breaking_white_space

				>>) |to| agent on_feature_header
			>>)
		end

	feature_header: like all_of
			--
		do
			Result := all_of (<<
				start_of_line,
				all_of (<<
					all_of (<<
						string_literal ("feature"),
						while_not_p1_repeat_p2 (
							string_literal ("--"),
							any_character
						),
						maybe_non_breaking_white_space

					>>) |to| agent on_feature_header,
					feature_comment,
					optional (field_insertion_marker)
				>>)
			>>)
		end

	feature_comment: like one_or_more
			--
		do
			Result := one_or_more (
				all_of (<< identifier, maybe_non_breaking_white_space >>)
			)	|to| agent on_feature_label
		end

	field_insertion_marker: like all_of
			--
		do
			Result := all_of (<<
				character_literal ('@')					|to| agent replace (?, ""),
				identifier									|to| agent on_new_attribute_name,
				return_type_signature_declaration   |to| agent on_new_attribute_type
			>>)
		end

feature {NONE} -- Parsing actions

	on_feature_header (text: EL_STRING_VIEW)
			--
		do
			if not insertion_marker_list.is_empty then
				put_string (insertion_marker_list.last)
			end
			put_string (text)
		end

	on_feature_label (text: EL_STRING_VIEW)
			--
		local
			insertion_marker, feature_label: ZSTRING
		do
			log.enter_with_args ("on_feature_label", << text.to_string_8 >>)
			feature_label := text
			feature_label.right_adjust

			create insertion_marker.make_from_latin_1 ("${insert_")
			insertion_marker.append  (feature_label)
			insertion_marker.append_character ('}')
			insertion_marker.replace_character (' ', '_')
			insertion_marker.to_lower

			insertion_marker_list.extend (insertion_marker)

			put_string (feature_label)
			log.exit
		end

	on_new_attribute_name (attribute_name: EL_STRING_VIEW)
			--
		do
			log.enter_with_args ("on_new_attribute_name", << attribute_name.to_string_8 >>)
			new_attribute_name := attribute_name
			log.exit
		end

	on_new_attribute_type (type_name_text: EL_STRING_VIEW)
			--
		do
			log.enter ("on_new_attribute_type")
			new_attribute_type := type_name_text
			new_attribute_type.left_adjust
			log.exit
		end

feature {NONE} -- Implementation

	insertion_marker_list: ARRAYED_LIST [STRING]

	new_attribute_name: STRING

	new_attribute_type: STRING

end

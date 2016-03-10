note
	description: "Summary description for {EIFFEL_FEATURE_LABEL_EXPANDER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 8:29:46 GMT (Monday 24th June 2013)"
	revision: "2"

class
	EIFFEL_FEATURE_LABEL_EXPANDER

inherit
	EIFFEL_SOURCE_EDITING_PROCESSOR
		redefine
			make_from_file
		end

create
	make_from_file

feature {NONE} -- Initialization

 	make_from_file (a_file_path: EL_FILE_PATH)
 			--
 		do
 			Precursor (a_file_path)
 			create class_export_list.make_empty
 		end

feature {NONE} -- Pattern definitions

	search_patterns: ARRAYED_LIST [EL_TEXTUAL_PATTERN]
		do
			create Result.make_from_array (<< unexported_feature, exported_feature >>)
		end

	exported_feature: EL_MATCH_ALL_IN_LIST_TP
		do
			Result := all_of (<<
				start_of_line,
				string_literal (Feature_leader) |to| agent on_unmatched_text,
				repeat (letter , 2 |..| 2) |to| agent on_feature_initials,
				end_of_line_character |to| agent on_unmatched_text
			>>)
		end

	unexported_feature: EL_MATCH_ALL_IN_LIST_TP
		local
			feature_leader_pattern: EL_MATCH_ALL_IN_LIST_TP
		do
			feature_leader_pattern := all_of (<<
				string_literal (Feature_leader),
				all_of (<<
					character_literal ('{'),
					optional (class_identifier),
					character_literal ('}')
				>>) |to| agent on_class_export_list
			>>)
			feature_leader_pattern.set_action_on_match_end (agent on_unexported_feature)

			Result := exported_feature
			Result.go_i_th (2)
			Result.replace (feature_leader_pattern)
		end

feature {NONE} -- Events

	on_feature_initials (text: EL_STRING_VIEW)
			--
		local
			initials: STRING
		do
			initials := text
			feature_catagories.search (initials)
			if feature_catagories.found then
				put_string (feature_catagories.found_item)
			else
				put_string (initials)
			end
		end

	on_unexported_feature (text: EL_STRING_VIEW)
			--
		do
			put_string (String.template ("feature $S -- ").substituted (<< class_export_list >>))
		end

	on_class_export_list (text: EL_STRING_VIEW)
			--
		do
			class_export_list := text
			if class_export_list.count = 2 then
				class_export_list.insert_string ("NONE", 2)
			end
		end

feature {NONE} -- Implementation

	feature_catagories: EL_ASTRING_HASH_TABLE [STRING]
		once
			create Result.make (<<
				["ac", 	"Access"],
				["bo", 	"Basic operations"],
				["co", 	"Constants"],
				["cp", 	"Comparison"],
				["cs", 	"Contract Support"],
				["cv", 	"Conversion"],
				["cm", 	"Cursor movement"],
				["dm", 	"Dimensions"],
				["dp", 	"Disposal"],
				["du", 	"Duplication"],
				["ec", 	"Element change"],
				["er", 	"Evolicity reflection"],
				["ev", 	"Event handling"],
				["im", 	"Implementation"],
				["ip", 	"Inapplicable"],
				["ia", 	"Internal attributes"],
				["in", 	"Initialization"],
				["me", 	"Measurement"],
				["mi",	"Miscellaneous"],
				["ob", 	"Obsolete"],
				["rm", 	"Removal"],
				["rs", 	"Resizing"],
				["sc", 	"Status change"],
				["sq", 	"Status query"],
				["sr", 	"Status report"],
				["td", 	"Type definitions"],
				["tf", 	"Transformation"],
				["un", 	"Unimplemented"]

			>>)
		end

	class_export_list: STRING

feature {NONE} -- Constants

	Feature_leader: STRING = "feature -- "

end

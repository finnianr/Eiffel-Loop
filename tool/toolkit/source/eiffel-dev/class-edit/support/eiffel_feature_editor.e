note
	description: "Summary description for {EIFFEL_FEATURE_EDITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EIFFEL_FEATURE_EDITOR

inherit
	EIFFEL_SOURCE_MODEL

feature -- Basic operations

	write_edited_lines (output_path: EL_FILE_PATH)
		local
			output: EL_PLAIN_TEXT_FILE
		do
			create output.make_open_write (output_path)
			output.set_encoding_from_name (encoding)
			output.put_lines (edited_lines)
			output.close
		end

feature {NONE} -- Implementation

	edited_lines: EL_ASTRING_LIST
		do
			create Result.make (class_notes.count + class_footer.count + class_header.count + feature_groups.count * 5)
			Result.append (class_notes)
			Result.append (class_header)
			across feature_groups as group loop
				Result.append (group.item.header)
				edit_feature_group (group.item.features)
				across group.item.features as l_feature loop
					Result.append (l_feature.item.lines)
				end
			end
			Result.append (class_footer)
		end

	edit_feature_group (feature_list: EL_SORTABLE_ARRAYED_LIST [CLASS_FEATURE])
		deferred
		end
end

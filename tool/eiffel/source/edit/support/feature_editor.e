note
	description: "Feature editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-06 11:11:39 GMT (Friday 6th March 2020)"
	revision: "6"

deferred class
	FEATURE_EDITOR

inherit
	SOURCE_MODEL

feature -- Basic operations

	write_edited_lines (output_path: EL_FILE_PATH)
		local
			output: SOURCE_FILE
		do
			create output.make_open_write (output_path)
			output.set_encoding_from_other (encoding)
			output.put_lines (edited_lines)
			output.close
		end

feature {NONE} -- Implementation

	edit_feature_group (feature_list: EL_ARRAYED_LIST [CLASS_FEATURE])
		deferred
		end

	edited_lines: EL_ZSTRING_LIST
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

feature {NONE} -- Constants

	Indented_keyword_end: ZSTRING
		once
			Result := "%Tend"
		end
end

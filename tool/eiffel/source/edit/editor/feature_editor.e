note
	description: "Feature editor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-07 11:08:31 GMT (Monday 7th November 2022)"
	revision: "11"

deferred class
	FEATURE_EDITOR

inherit
	SOURCE_MODEL
		rename
			make as make_model
		end

feature {NONE} -- Initialization

	make (a_source_path: FILE_PATH; dry_run: BOOLEAN)
		do
			make_model (a_source_path)
			is_dry_run := dry_run
		end

feature -- Status query

	is_dry_run: BOOLEAN

feature -- Basic operations

	write_edited_lines (output_path: FILE_PATH)
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
			create Result.make (class_notes.count + class_footer.count + class_header.count + feature_group_list.string_count)
			Result.append (class_notes)
			Result.append (class_header)
			across feature_group_list as group loop
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
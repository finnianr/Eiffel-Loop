note
	description: "Eiffel source-code feature editor extending class ${SOURCE_MODEL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-07 14:23:45 GMT (Wednesday 7th May 2025)"
	revision: "14"

deferred class
	FEATURE_EDITOR

inherit
	SOURCE_MODEL
		rename
			make as make_model
		end

feature {NONE} -- Initialization

	make (a_source_path: FILE_PATH; a_dry_run: BOOLEAN)
		do
			make_model (a_source_path)
			dry_run := a_dry_run
		end

feature -- Status query

	dry_run: EL_BOOLEAN_OPTION

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
			create Result.make (
				class_notes.count + class_footer.count + class_header.count + feature_group_list.string_count
			)
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
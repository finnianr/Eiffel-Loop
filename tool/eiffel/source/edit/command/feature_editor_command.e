note
	description: "[
		A ${FEATURE_EDITOR} for peforming expansions of code shorthand expressions.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-08 6:06:24 GMT (Thursday 8th May 2025)"
	revision: "30"

class
	FEATURE_EDITOR_COMMAND

inherit
	EL_APPLICATION_COMMAND

	FEATURE_EDITOR
		export
			{EL_COMMAND_CLIENT} make
			{NONE} write_edited_lines
		redefine
			call
		end

create
	make

feature -- Constants

	Description: STRING = "Performs a series of edits and shorthand expansions on an Eiffel class"

feature -- Basic operations

	execute
		do
			if dry_run.is_enabled then
				lio.put_labeled_string ("Dry run modified text", source_path.without_extension.base.as_upper)
				lio.put_new_line
			 	across edited_lines as line loop
			 		line.item.expand_tabs (3)
			 		lio.put_line (line.item)
			 	end
			else
				write_edited_lines (source_path)
			end
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		do
			if line.starts_with (Feature_abbreviation) then
				expand (line)
			end
			Precursor (line)
		end

	edit_feature_group (feature_list: EL_ARRAYED_LIST [CLASS_FEATURE])
		do
			across feature_list as list loop
				list.item.expand_shorthand
				Alignment_editor.edit (list.item.lines) -- Right justify tuple items in array
			end
			feature_list.order_by (agent {CLASS_FEATURE}.name, True)
		end

	expand (line: ZSTRING)
		local
			old_line, code: ZSTRING; parts: EL_ZSTRING_LIST
		do
			create parts.make_word_split (line)
			if parts.first ~ Feature_abbreviation and parts.count = 2 then
				old_line := line.twin
				line.wipe_out
				line.grow (50)
				line.append_string (Keyword.feature_)
				line.append_character (' ')
				code := parts.i_th (2)
				if code [1] = '{' then
					line.append_string (None_access_modifier)
					line.append_character (' ')
					code.remove_head (1)
				end
				line.append_string (Comment_prefix)
				if Feature_expansion_table.has_key_general (code) then
					line.append_string_general (Feature_expansion_table.found_item)
				else
					line.append (code)
				end
				if is_lio_enabled then
					lio.put_labeled_string (old_line, line)
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Constants

	Alignment_editor: TUPLE_MANIFEST_ALIGNMENT_EDITOR
		once
			create Result.make
		end

	Comment_prefix: ZSTRING
		once
			Result := "-- "
		end

	None_access_modifier: ZSTRING
		once
			Result := "{NONE}"
		end

	Feature_abbreviation: ZSTRING
		once
			Result := "@f"
		end

end
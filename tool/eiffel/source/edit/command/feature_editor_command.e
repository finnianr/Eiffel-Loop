note
	description: "[
		Command for command-line sub-application: [$source FEATURE_EDITOR_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 15:15:27 GMT (Monday 5th December 2022)"
	revision: "17"

class
	FEATURE_EDITOR_COMMAND

inherit
	EL_APPLICATION_COMMAND

	FEATURE_EDITOR
		export
			{EL_COMMAND_CLIENT} make
		redefine
			call
		end

create
	make

feature -- Constants

	Description: STRING = "Performs a series of edits and shorthand expansions on an Eiffel class"

feature -- Basic operations

	execute
		local
			s: EL_ZSTRING_ROUTINES
		do
			if is_dry_run then
				lio.put_labeled_string ("Dry run modified text", source_path.without_extension.base.as_upper)
				lio.put_new_line
			 	across edited_lines as line loop
			 		line.item.replace_substring_all (s.character_string ('%T'), s.n_character_string (' ', 3))
			 		lio.put_line (line.item)
			 	end
			else
				write_edited_lines (source_path)
			end
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		do
			if line.starts_with_zstring (Feature_abbreviation) then
				expand (line)
			end
			Precursor (line)
		end

	edit_feature_group (feature_list: EL_ARRAYED_LIST [CLASS_FEATURE])
		do
			feature_list.do_all (agent {CLASS_FEATURE}.expand_shorthand)
			feature_list.order_by (agent {CLASS_FEATURE}.name, True)
		end

	expand (line: ZSTRING)
		local
			old_line, code: ZSTRING
			parts: EL_ZSTRING_LIST
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
				Feature_catagories.search (code)
				if Feature_catagories.found then
					line.append_string (Feature_catagories.found_item)
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
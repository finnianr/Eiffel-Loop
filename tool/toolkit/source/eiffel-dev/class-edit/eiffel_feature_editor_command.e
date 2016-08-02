note
	description: "[
		Command for command-line sub-application:
		[../../../application/eiffel_feature_editor_command_app.html `EIFFEL_FEATURE_EDITOR_COMMAND_APP']
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-13 7:54:18 GMT (Wednesday 13th July 2016)"
	revision: "1"

class
	EIFFEL_FEATURE_EDITOR_COMMAND

inherit
	EIFFEL_FEATURE_EDITOR
		export
			{EL_COMMAND_LINE_SUB_APPLICATION} make
		redefine
			call
		end

	EL_COMMAND

create
	make, default_create

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			write_edited_lines (source_path)
			log.exit
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		do
			if line.starts_with (Feature_abbreviation) then
				expand (line)
			end
			Precursor (line)
		end

	edit_feature_group (feature_list: EL_SORTABLE_ARRAYED_LIST [CLASS_FEATURE])
		do
			feature_list.do_all (agent {CLASS_FEATURE}.expand_shorthand)
			feature_list.sort
		end

	expand (line: ZSTRING)
		local
			old_line, code: ZSTRING
			parts: EL_ZSTRING_LIST
		do
			create parts.make_with_words (line)
			if parts.first ~ Feature_abbreviation and parts.count = 2 then
				old_line := line.twin
				line.wipe_out
				line.grow (50)
				line.append_string (Keyword_feature)
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
				lio.put_labeled_string (old_line, line)
				lio.put_new_line
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
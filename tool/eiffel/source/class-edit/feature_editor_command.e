note
	description: "[
		Command for command-line sub-application: [$source `EIFFEL_FEATURE_EDITOR_APP']
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-18 10:52:21 GMT (Wednesday 18th October 2017)"
	revision: "4"

class
	FEATURE_EDITOR_COMMAND

inherit
	FEATURE_EDITOR
		export
			{EL_COMMAND_CLIENT} make
		redefine
			call
		end

	EL_COMMAND

create
	make

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

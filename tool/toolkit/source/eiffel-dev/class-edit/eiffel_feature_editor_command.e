note
	description: "[
		Performs the following edits and shorthand expansions on an Eiffel class.
		
		**1.** Expands `@f xx' as `feature -- <comment>' where xx is a 2 letter code representing
		common feature block labels
			
		**2.** Expands `@f {xx' as `feature {NONE} -- <label-xx>' where `xx' is a 2 letter code
		representing common feature labels. See class: `FEATURE_CONSTANTS'
		
		**3.** Expands setter shorthand `@set name' (indented by one tab) as follows:
			set_name (a_name: like name)
				do
					name := a_name
				end
					
		**4.** Expands value iteration shorthand of the form `@from i > n' as follows:
			from i := 1 until i > n loop
				i := i + 1
			end
				
		**5.** Expands list iteration shorthand of the form `@from list.after' as follows:
			from list.start until list.after loop
				list.forth
			end
				
		**6.** Expands list iteration shorthand of the form `@from list.before' as follows:
			from list.finish until list.before loop
				list.back
			end
				
		**7.** Reorders features in each feature block alphabetically
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 7:22:11 GMT (Friday 8th July 2016)"
	revision: "5"

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

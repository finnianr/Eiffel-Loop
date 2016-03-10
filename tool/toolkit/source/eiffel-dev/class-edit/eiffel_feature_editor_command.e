note
	description: "Summary description for {EIFFEL_FEATURE_EDITOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	call (line: ASTRING)
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

	expand (line: ASTRING)
		local
			old_line, code: ASTRING
			parts: EL_ASTRING_LIST
		do
			create parts.make_with_words (line)
			if parts.first ~ Feature_abbreviation and parts.count = 2 then
				old_line := line.twin
				line.wipe_out
				line.grow (50)
				line.append_string ("feature ")
				code := parts.i_th (2)
				if code [1] = '{' then
					line.append_string ("{NONE} ")
					code.remove_head (1)
				end
				line.append_string ("-- ")
				Feature_catagories.search (code)
				if Feature_catagories.found then
					line.append (Feature_catagories.found_item)
				else
					line.append (code)
				end
				log_or_io.put_labeled_string (old_line, line)
				log_or_io.put_new_line
			end
		end

feature {NONE} -- Constants

	Feature_abbreviation: ASTRING
		once
			Result := "@f"
		end

end

note
	description: "Summary description for {THUNDERBIRD_MAIL_TO_XHTML_CONVERTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 19:58:44 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	THUNDERBIRD_MAIL_TO_XHTML_CONVERTER

inherit
	THUNDERBIRD_MAIL_CONVERTER
		rename
			find_start as find_html
		redefine
			make, call
		end

create
	make

feature {NONE} -- Initialization

	make (a_output_dir: EL_DIR_PATH)
			--
		do
			Precursor (a_output_dir)
			create html.make (50)

			break_tag := XML.empty_tag ("br")

			create substitutions.make_from_array (<<
				["%T", 		XML.entity ({ASCII}.Tabulation.to_natural_32)],
				["<br>", 	break_tag]
			>>)
		end

feature {NONE} -- State handlers

	find_html (line: EL_ASTRING)
		do
			if line.starts_with ("<html>") then
				html.extend (XML_header)
				html.extend (line)
				state := agent find_meta
			end
		end

	find_meta (line: EL_ASTRING)
		do
			if trim_line.starts_with ("<meta ") then
				state := agent find_meta_tag_end
				find_meta_tag_end (line)
			else
				html.extend (line)
			end
		end

	find_meta_tag_end (line: EL_ASTRING)
			--
		do
			if trim_line.starts_with ("charset=") then
				line.remove_tail (line.last_index_of ('=', line.count) - 1)
				line.append ("UTF-8%"/>")
				state := agent find_end_tag (?, "</html>")
			end
			html.extend (line)
		end

feature {NONE} -- Implementation

	call (line: EL_ASTRING)
		-- call state procedure with item
		do
			from substitutions.start until substitutions.after loop
				line.replace_substring_all (substitutions.item.original, substitutions.item.new)
				substitutions.forth
			end
			if last_header.charset ~ "ISO-8859-1" then
				Precursor (substitute_html_entities (line))
			else
				Precursor (line)
			end
		end

	write_line (line: EL_ASTRING; file_out: PLAIN_TEXT_FILE)
		do
			file_out.put_string (line.to_utf8)
			file_out.put_new_line
		end

	substitute_html_entities (line: EL_ASTRING): EL_ASTRING
		local
			parts: LIST [EL_ASTRING]
			semi_colon_pos: INTEGER
		do
			parts := line.split ('&')
			if parts.count = 1 then
				Result := line
			else
				create Result.make (line.count)
				parts.start
				Result.append (parts.item)
				parts.forth
				from until parts.after loop
					semi_colon_pos := parts.item.index_of (';', 1)
					if semi_colon_pos > 0 then
						Result.append (XML.entity (Entity_numbers [parts.item.substring (1, semi_colon_pos - 1)]))
						Result.append (parts.item.substring (semi_colon_pos + 1, parts.item.count))
					end
					parts.forth
				end
			end
		end

	file_out_extension: EL_ASTRING
		do
			Result := "xhtml"
		end

	substitutions: ARRAYED_LIST [TUPLE [original: STRING; new: EL_ASTRING]]

feature {NONE} -- Constants

	XML_header: STRING = "[
		<?xml version="1.0" encoding="UTF-8"?>
	]"

end

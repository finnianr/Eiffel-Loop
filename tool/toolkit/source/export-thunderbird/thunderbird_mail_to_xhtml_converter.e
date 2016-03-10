note
	description: "Summary description for {THUNDERBIRD_MAIL_TO_XHTML_CONVERTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:33 GMT (Tuesday 2nd September 2014)"
	revision: "5"

class
	THUNDERBIRD_MAIL_TO_XHTML_CONVERTER

inherit
	THUNDERBIRD_MAIL_CONVERTER [XHTML_WRITER]
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
			create html_lines.make (50)
		end

feature {NONE} -- State handlers

	find_html (line: ASTRING)
		do
			if line.starts_with ("<html>") then
				extend_html (XML_header)
				extend_html (line)
				state := agent find_meta_tag
			end
		end

	find_meta_tag (line: ASTRING)
			-- close meta tag with forward slash
			-- <meta content=".."/>
		do
			if line.starts_with (Meta_tag_start) then
				state := agent find_meta_tag_close
				find_meta_tag_close (line)

			elseif line.starts_with (Head_tag_close) then
				state := agent find_end_tag
				extend_html (line)
			else
				extend_html (line)
			end
		end

	find_meta_tag_close (line: ASTRING)
		do
			if line [line.count] = '>' then
				line.insert_character ('/', line.count)
				state := agent find_meta_tag
			end
			extend_html (line)
		end

feature {NONE} -- Implementation

	call (line: ASTRING)
		-- call state procedure with item
		do
			if last_header.charset ~ "ISO-8859-1" then
				Precursor (substitute_html_entities (line))
			else
				Precursor (line)
			end
		end

	substitute_html_entities (line: ASTRING): ASTRING
		local
			parts: LIST [ASTRING]
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

	file_out_extension: ASTRING
		do
			Result := "xhtml"
		end

feature {NONE} -- Constants

	End_tag: STRING
		once
			Result := XML.closed_tag ("html")
		end

	XML_header: STRING = "[
		<?xml version="1.0" encoding="UTF-8"?>
	]"

	Meta_tag_start: ASTRING
		once
			Result := "<meta"
		end

	Head_tag_close: ASTRING
		once
			Result := XML.closed_tag ("head")
		end

end

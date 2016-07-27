note
	description: "[
		Find CRC-32 digest in HTML
			
			<meta name="digest" content="<crc digest>"/>

	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_HTML_META_DIGEST_PARSER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

feature {NONE} -- Initialization

	make (html_path: EL_FILE_PATH)
		do
			make_machine
			if html_path.exists then
				do_once_with_file_lines (agent find_meta_digest, create {EL_FILE_LINE_SOURCE}.make_latin (1, html_path))
			end
		end

feature {NONE} -- Line states: find meta checksum

	find_meta_digest (line: ZSTRING)
		do
			if line.has_substring (Digest_value) then
				meta_crc_digest := line.substring_between (Content_assignment, Meta_close, 1).to_natural
				state := agent final
			end
		end

feature {NONE} -- Internal attributes

	meta_crc_digest: NATURAL
		-- digest in HTML

feature {NONE} -- Constants

	Content_assignment: ZSTRING
		once
			Result := "content=%""
		end

	Digest_value: ZSTRING
		once
			Result := "[
				"digest"
			]"
		end

	Meta_close: ZSTRING
		once
			Result := "%"/>"
		end

end

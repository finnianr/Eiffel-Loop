note
	description: "Summary description for {EL_HTML_PROPERTIES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_HTML_PROPERTIES

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		redefine
			default_create, call
		end

	EL_ENCODEABLE_AS_TEXT
		undefine
			default_create
		end

create
	make, default_create

feature {NONE} -- Initialization

	default_create
		do
			create content_type.make_empty
		end

	make (a_file_path: EL_FILE_PATH)
		local
			lines: EL_FILE_LINE_SOURCE
		do
			create lines.make (a_file_path)
			do_with_lines (agent find_charset, lines)
		end

feature -- Access

	content_type: STRING

feature {NONE} -- State handlers

	find_charset (line: EL_ASTRING)
		do
			if line.starts_with ("<meta") and then line.has_substring ("content=") then
				content_type := line.split ('"').i_th (4).as_string_8
				set_encoding_from_name (content_type.substring (content_type.index_of ('=', 1) + 1, content_type.count))
				state := agent final
			end
		end

feature {NONE} -- Implementation

	call (line: EL_ASTRING)
		-- call state procedure with item
		do
			line.left_adjust
			state.call ([line])
		end

end

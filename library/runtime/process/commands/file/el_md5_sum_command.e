note
	description: "Wrapper for Unix md5sum command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-21 15:58:33 GMT (Sunday 21st May 2023)"
	revision: "6"

class
	EL_MD5_SUM_COMMAND

inherit
	EL_CAPTURED_OS_COMMAND_IMP
		rename
			make_default as make
		end

create
	make

feature -- Access

	sum: STRING
		-- checksum result

	target_path: FILE_PATH

feature -- Element change

	set_target_path (a_path: FILE_PATH)
		do
			target_path := a_path
		end

feature {NONE} -- Implementation

	do_with_lines (output_lines: like new_output_lines)
		local
			pos: INTEGER
		do
			across output_lines as line until pos > 0 loop
				pos := line.item.index_of ('*', 1)
				if pos > 0 then
					sum := line.item.substring (1, pos - 1)
					sum.right_adjust
				end
			end
			if pos = 0 then
				create sum.make_empty
			end
		end

feature {NONE} -- Constants

	Template: STRING = "md5sum -b $target_path"

end
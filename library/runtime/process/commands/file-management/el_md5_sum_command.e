note
	description: "Wrapper for Unix md5sum command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 15:37:09 GMT (Thursday 9th September 2021)"
	revision: "2"

class
	EL_MD5_SUM_COMMAND

inherit
	EL_PARSED_CAPTURED_OS_COMMAND [TUPLE [target_path: STRING]]
		redefine
			execute
		end

create
	execute, make

feature -- Access

	sum: STRING
		-- checksum result

feature -- Element change

	set_target_path (a_path: EL_FILE_PATH)
		do
			put_path (var.target_path, a_path)
		end

feature -- Basic operations

	execute
		local
			pos: INTEGER
		do
			Precursor
			if not has_error and then lines.count > 0 then
				pos := lines.first.index_of ('*', 1)
				if pos > 0 then
					lines.first.substring (1, pos - 1).append_to_string_8 (sum)
					sum.right_adjust
				end
			end
		end

feature {NONE} -- Constants

	Template: STRING = "md5sum -b $target_path"

end
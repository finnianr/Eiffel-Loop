note
	description: "Parser for file `project.py' used to configure Eiffel-Loop scons build system"
	notes: "[
		Detects lines
			
			if platform.system () == "Windows":
				.. A
			else:
				.. B
				
		and scans either section A or B depending on platform
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 10:57:33 GMT (Thursday 16th June 2022)"
	revision: "5"

class
	SCONS_PROJECT_PY_CONFIG

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		redefine
			make_default
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		undefine
			is_equal
		end

	EL_MAKEABLE
		undefine
			is_equal
		end

	EL_MODULE_TUPLE

	PACKAGE_BUILD_CONSTANTS

create
	make_from_file, make

feature {NONE} -- Initialization

	make
		-- assuming project.py is in current directory
		do
			if Project_py.exists then
				make_from_file (Project_py)
			else
				make_default
			end
		end

	make_default
		do
			Precursor
			make_machine
			left_adjusted := True
			build_info_path := "source/build_info.e"
		end

	make_from_file (file_path: FILE_PATH)
		require
			file_exists: file_path.exists
		do
			make_default
			if attached open_lines (file_path, Latin_1) as lines then
				do_once_with_file_lines (agent do_with_line, lines)
			end
			if ecf.has ('.') then
				pecf_path := ecf
				pecf_path.replace_extension ("pecf")
			end
		end

feature -- Access

	build_info_path: FILE_PATH

	ecf: ZSTRING
		-- source to create instance of `SOFTWARE_INFO'

	pecf_path: FILE_PATH

feature {NONE} -- Line states

	do_with_line (line: ZSTRING)
		local
			pos_equal, pos_quote: INTEGER; found: BOOLEAN
		do
			if line.starts_with (Code.if_platform_system) and then line.has_substring (Code.windows) then
				if {PLATFORM}.is_windows then
					-- Do not scan section B
					finish_at_else := True
				else
					-- Skip section A
					state := agent find_else
				end

			elseif line.starts_with (Code.else_) then
				if finish_at_else then
					state := final
				end
			else
				across field_table as table until found loop
					if line.starts_with (table.item.name) then
						pos_equal := line.index_of ('=', table.item.name.count + 1)
						if pos_equal > 0 then
							across once "%"'" as quote until found loop
								if line.occurrences (quote.item) = 2 then
									pos_quote := line.index_of (quote.item, pos_equal + 1)
									table.item.set_from_string (Current, line.substring (pos_quote + 1, line.count - 1))
									found := True
								end
							end
						end
					end
				end
			end
		end

	find_else (line: ZSTRING)
		-- find else: statement
		do
			if line.starts_with (Code.else_) then
				state := agent do_with_line
			end
		end

feature {NONE} -- Internal attributes

	finish_at_else: BOOLEAN

feature {NONE} -- Constants

	Code: TUPLE [else_, if_platform_system, windows:ZSTRING]
		once
			create Result
			Tuple.fill (Result, "else:, if platform.system, Windows")
		end

end
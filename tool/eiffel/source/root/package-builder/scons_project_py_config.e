note
	description: "Parser for file `project.py' used to configure Eiffel-Loop scons build system"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-07 9:47:22 GMT (Saturday 7th August 2021)"
	revision: "2"

class
	SCONS_PROJECT_PY_CONFIG

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
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

	PACKAGE_BUILD_CONSTANTS

create
	make_from_file, make

feature {NONE} -- Initialization

	make_from_file (file_path: EL_FILE_PATH)
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
			build_info_path := "source/build_info.e"
		end

feature -- Access

	build_info_path: EL_FILE_PATH

	ecf: ZSTRING
		-- source to create instance of `SOFTWARE_INFO'

	pecf_path: EL_FILE_PATH

feature {NONE} -- Line states

	do_with_line (line: ZSTRING)
		local
			pos_equal, pos_quote: INTEGER; found: BOOLEAN
		do
			across field_table as table loop
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
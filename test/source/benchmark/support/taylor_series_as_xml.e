note
	description: "Generate Taylor series for Pi in a number of separate XML files"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-01 19:36:51 GMT (Saturday 1st February 2020)"
	revision: "2"

class
	TAYLOR_SERIES_AS_XML

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		redefine
			make_default, serialize
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make (dir_path: EL_DIR_PATH)
		do
			File_system.make_directory (dir_path)
			make_from_file (dir_path + "pi-terms.000.xml")
		end

	make_default
		do
			create path_list.make_with_count (20)
			create term_list.make (100)
			Precursor
		end

feature -- Access

	path_list: EL_FILE_PATH_LIST

feature -- Basic operations

	cleanup
		do
			across path_list as file_path loop
				File_system.remove_file (file_path.item)
			end
		end

	generate
			-- This is a heavy duty test
		local
			pi, term: DOUBLE; numerator, divisor: INTEGER
		do
			numerator := 4; divisor := 1
			from term := numerator until term.abs < limit loop
				if divisor \\ 1000 = 1 then
					if divisor > 1 then
						serialize
					end
				end
				term_list.extend (create {TAYLOR_TERM}.make (numerator, divisor))
				pi := pi + term
				numerator := numerator.opposite
				divisor := divisor + 2
				term := numerator / divisor
			end
			serialize
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["Current", agent: ITERABLE [TAYLOR_TERM] do Result := term_list end]
			>>)
		end

feature {NONE} -- Implementation

	serialize
		do
			output_path := output_path.next_version_path
			path_list.extend (output_path)
			lio.put_path_field ("Serializing", output_path)
			lio.put_new_line
			Precursor
			term_list.wipe_out
		end

feature {NONE} -- Internal attributes

	term_list: ARRAYED_LIST [TAYLOR_TERM]

feature {NONE} -- Constants

	Limit: DOUBLE = 0.5E-4

	Template: STRING = "[
		<?xml version="1.0" encoding="UTF-8"?>
		<pi-series>
		#across $Current as $term loop
			<term>
				<numerator>$term.item.numerator</numerator>
				<divisor>$term.item.divisor</divisor>
			</term>
		#end
		</pi-series>
	]"

end

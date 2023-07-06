note
	description: "A4/A5 paper size routines and constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-06 11:37:46 GMT (Thursday 6th July 2023)"
	revision: "1"

deferred class
	EL_PAPER_SIZE_ROUTINES

inherit
	EL_MODULE_SCREEN; EL_MODULE_TUPLE

feature {NONE} -- Implementation

	best_paper_size: NATURAL_8
		-- best paper size fit for size of display
		local
			useable_height_cms: REAL; useable_proportion: DOUBLE
		do
			useable_proportion := Screen.useable_area.height / Screen.height
			useable_height_cms := Screen.height_cms * useable_proportion.truncated_to_real
			if useable_height_cms > real_dimension (A5_code).width then
				Result := A4_code
			else
				Result := A5_code
			end
		end

	code_name (paper_code: NATURAL_8): STRING
		do
			create Result.make_filled ('A', 2)
			Result [2] := '0' + paper_code.to_integer_32
		end

	new_dimension (width_height: STRING): like Dimension_table.item
		do
			create Result
			Tuple.fill (Result, width_height)
		end

	real_dimension (paper_code: NATURAL_8): like Real_dimension_table.item
		do
			if Real_dimension_table.has_key (paper_code) then
				Result := Real_dimension_table.found_item
			else
				Result := Real_dimension_table [A5_code]
			end
		end

feature {NONE} -- Constants

	A4_code: NATURAL_8 = 4

	A5_code: NATURAL_8 = 5

	Real_dimension_table: EL_HASH_TABLE [TUPLE [width, height: REAL], NATURAL_8]
		once
			create Result.make_size (2)
			across Dimension_table as table loop
				if attached table.item as paper then
					Result.extend ([paper.width.to_real, paper.height.to_real], table.key)
				end
			end
		end

	Dimension_table: EL_HASH_TABLE [TUPLE [width, height: STRING], NATURAL_8]
		once
			create Result.make (<<
				[A5_code, new_dimension ("21, 14.8")],
				[A4_code, new_dimension ("29.7, 21")]
			>>)
		end
end
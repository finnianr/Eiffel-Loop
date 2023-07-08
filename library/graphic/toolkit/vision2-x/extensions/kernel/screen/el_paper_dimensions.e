note
	description: "A4/A5 paper dimensions as reals and string tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-07 20:38:27 GMT (Friday 7th July 2023)"
	revision: "4"

class
	EL_PAPER_DIMENSIONS

inherit
	ANY

	EL_MODULE_SCREEN; EL_MODULE_TUPLE

create
	make, make_best_fit

feature {NONE} -- Initialization

	make (a_code: INTEGER; width_cms_height_cms: STRING)
		require
			comma_separated: width_cms_height_cms.occurrences (',') = 1
		do
			create as_tuple
			Tuple.fill (as_tuple, width_cms_height_cms)
			width_cms := as_tuple.width_cms.to_real
			height_cms := as_tuple.height_cms.to_real

			create id.make_filled ('A', 2)
			id.put('0' + a_code, 2)
		ensure
			reversible: code = a_code
		end

	make_best_fit
		-- best paper size fit for reported size of useable display area
		local
			useable_height_cms: REAL; useable_proportion: DOUBLE
		do
			make (5 ,"21, 14.8") -- default A5 dimensions

			useable_proportion := Screen.useable_area.height / Screen.height
			useable_height_cms := Screen.height_cms * useable_proportion.truncated_to_real

			if useable_height_cms > width_cms then
				make (4 ,"29.7, 21") -- promote to A4 dimensions
			end
		end

feature -- Access

	as_tuple: TUPLE [width_cms, height_cms: STRING]

	as_rectangle: EL_RECTANGLE
		do
			Result := [width_cms.to_double, height_cms.to_double]
		end

	height_cms: REAL

	id: STRING

	width_cms: REAL

	code: INTEGER
		do
			Result := id [2].code - ('0').code
		end

feature -- Status query

	is_A4: BOOLEAN
		do
			Result := code = 4
		end

	is_A5: BOOLEAN
		do
			Result := code = 5
		end
end
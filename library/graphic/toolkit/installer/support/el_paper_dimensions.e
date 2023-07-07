note
	description: "A4/A5 paper dimensions as reals and string tuple"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-07 8:45:31 GMT (Friday 7th July 2023)"
	revision: "1"

class
	EL_PAPER_DIMENSIONS

inherit
	ANY

	EL_MODULE_SCREEN; EL_MODULE_TUPLE

create
	make, make_best_fit

feature {NONE} -- Initialization

	make_best_fit
		-- best paper size fit for reported size of display
		local
			useable_height_cms: REAL; useable_proportion: DOUBLE
		do
			make (5 ,"21, 14.8") -- A5

			useable_proportion := Screen.useable_area.height / Screen.height
			useable_height_cms := Screen.height_cms * useable_proportion.truncated_to_real

			if useable_height_cms > width_cms then
				make (4 ,"29.7, 21") -- A4
			end
		end

	make (code: INTEGER; width_cms_height_cms: STRING)
		require
			comma_separated: width_cms_height_cms.occurrences (',') = 1
		do
			create as_tuple
			Tuple.fill (as_tuple, width_cms_height_cms)
			width_cms := as_tuple.width_cms.to_real
			height_cms := as_tuple.height_cms.to_real

			create id.make_filled ('A', 2)
			id.put('0' + code, 2)
		end

feature -- Access

	as_tuple: TUPLE [width_cms, height_cms: STRING]

	width_cms: REAL

	height_cms: REAL

	id: STRING
end
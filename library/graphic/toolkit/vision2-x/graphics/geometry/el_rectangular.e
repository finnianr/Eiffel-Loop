note
	description: "Rectangular shape"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_RECTANGULAR

inherit
	EL_MODULE_ORIENTATION

feature -- Measurement

	height: INTEGER
		deferred
		end

	width: INTEGER
		deferred
		end

feature -- Access

	fit_adjustment (target: EL_RECTANGLE): TUPLE [dimension: NATURAL_8; x, y, size: INTEGER]
		-- adjustments needed to center and fit current rectangle on `target' rectangle
		local
			rect: EL_RECTANGLE
		do
			rect := dimensions
			if rect.same_size (target) then
				Result := [{EL_DIRECTION}.By_width.zero, 0, 0, 0]

			elseif rect.same_aspect (target) then
				Result := [{EL_DIRECTION}.By_width, 0, 0, target.width]

			elseif rect.aspect_ratio < target.aspect_ratio then
				-- adjust height and center horizontally
				rect.scale_to_height (target.height)
				rect.move_center (target)
				Result := [{EL_DIRECTION}.By_height, rect.x, rect.y, target.height]
			else
				-- adjust width and center vertically
				rect.scale_to_width (target.width)
				rect.move_center (target)
				Result := [{EL_DIRECTION}.By_width, rect.x, rect.y, target.width]
			end
		end

	dimensions: EL_RECTANGLE
		do
			create Result.make_size (width, height)
		end

	scaled_dimensions (dimension: NATURAL_8; size: INTEGER): EL_RECTANGLE
		require
			valid_dimension: Orientation.is_valid_dimension (dimension)
		do
			Result := dimensions
			Result.scale_to_size (dimension, size)
		end

end
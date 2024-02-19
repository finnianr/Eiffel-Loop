note
	description: "Rectangular shape"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-14 11:31:19 GMT (Wednesday 14th February 2024)"
	revision: "3"

deferred class
	EL_RECTANGULAR

inherit
	EL_MODULE_ORIENTATION

	EL_DIRECTION_CONSTANTS

feature -- Measurement

	dimension_size (dimension: NATURAL_8): INTEGER
		require
			valid_dimension: Orientation.is_valid_dimension (dimension)
		do
			inspect dimension
				when By_width then
					Result := width
			else
				Result := height
			end
		end

	height: INTEGER
		deferred
		end

	width: INTEGER
		deferred
		end

feature -- Access

	fit_adjustment (target: EL_RECTANGLE): TUPLE [dimension: NATURAL_8; x, y, size: INTEGER; same_size: BOOLEAN]
		-- adjustments needed to center and fit current rectangle on `target' rectangle
		do
			if attached dimensions as this then
				if this.same_size (target) then
					Result := [By_width.zero, 0, 0, 0, True]

				elseif this.same_aspect (target) then
					Result := [By_width, 0, 0, target.width, False]

				elseif this.aspect_ratio < target.aspect_ratio then
					-- adjust height and center horizontally
					this.scale_to_height (target.height)
					this.move_center (target)
					Result := [By_height, this.x, this.y, target.height, False]
				else
					-- adjust width and center vertically
					this.scale_to_width (target.width)
					this.move_center (target)
					Result := [By_width, this.x, this.y, target.width, False]
				end
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
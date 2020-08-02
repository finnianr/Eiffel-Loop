note
	description: "Root parameters"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-02 10:12:55 GMT (Sunday 2nd August 2020)"
	revision: "3"

class
	ROOT_PARAMETERS

inherit
	SATELLITE_PARAMETERS

create
	make_default

feature -- Factory

	new_model: REPLICATED_IMAGE_MODEL
		local
			rectangle: EL_RECTANGLE; drawing: CAIRO_DRAWING_AREA
		do
			image_path.expand
			create drawing.make_with_path (image_path)
			create rectangle.make (0, 0, drawing.width, drawing.height)
			create Result.make (rectangle.to_point_array, drawing)
			across transformation_list as transform loop
				transform.item (Result)
			end
		end

feature {NONE} -- Internal attributes

	image_path: EL_FILE_PATH

end

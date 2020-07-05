note
	description: "Root parameters"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-05 13:33:27 GMT (Wednesday 5th June 2019)"
	revision: "1"

class
	ROOT_PARAMETERS

inherit
	SATELLITE_PARAMETERS

create
	make_default

feature -- Factory

	new_model: REPLICATED_IMAGE_MODEL
		local
			rectangle: EL_RECTANGLE; image: EL_DRAWABLE_PIXEL_BUFFER
		do
			image_path.expand
			create image.make_with_path (32, image_path)
			create rectangle.make (0, 0, image.width, image.height)
			create Result.make (rectangle.to_point_array, image)
			across transformation_list as transform loop
				transform.item (Result)
			end
		end

feature {NONE} -- Internal attributes

	image_path: EL_FILE_PATH

end

note
	description: "Summary description for {MODEL_ELECTRON}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:14:13 GMT (Monday 24th June 2013)"
	revision: "2"

class
	MODEL_ELECTRON

inherit
	EV_MODEL_PICTURE
		redefine
			scale
		end

	EL_MODULE_IMAGE
		undefine
			copy , default_create
		end

create
	make, default_create

feature {NONE} -- Initialization

	make
			--
		do
			make_with_pixmap (Tennis_ball_image)
			original_id_pixmap := id_pixmap
		end

feature -- Basic operations

	scale (a_scale: DOUBLE)
			-- Scale to x and y direction for `a_scale'.
		do
			id_pixmap := original_id_pixmap
			pixmap_factory.register_pixmap (id_pixmap)
--			scaled_pixmap := pixmap
			point_array.item (1).set_x_precise (point_array.item (0).x_precise + pixmap.width)
			point_array.item (2).set_y_precise (point_array.item (0).y_precise + pixmap.height)
			precursor (a_scale)
		end

feature {NONE} -- Implementation

	original_id_pixmap: like id_pixmap

feature {NONE} -- Constants

	Tennis_ball_image: EV_PIXMAP
			--
		once
			Result := Image.pixmap (<< "tennis-ball.png" >>)
		end

end

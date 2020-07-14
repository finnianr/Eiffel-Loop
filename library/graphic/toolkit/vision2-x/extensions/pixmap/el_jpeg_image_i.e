note
	description: "JPEG file interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-14 14:45:47 GMT (Tuesday 14th July 2020)"
	revision: "4"

deferred class
	EL_JPEG_IMAGE_I

inherit
	EV_ANY_HANDLER

	EL_MODULE_EXCEPTION

	EL_POINTER_ROUTINES

feature {NONE} -- Initialization

	make (component: EV_ANY_I; a_quality: NATURAL)
		require
			valid_type: attached {EV_PIXMAP_I} component or attached {EL_DRAWABLE_PIXEL_BUFFER_I} component
			buffer_is_rgb_24: attached {EL_DRAWABLE_PIXEL_BUFFER_I} component as buffer implies buffer.is_rgb_24_format
			percentage: 0 <= a_quality and a_quality <= 100
		do
			pixel_component := component; quality := a_quality
		end

feature -- Access

	quality: NATURAL

feature -- Basic operations

	save_as (a_file_path: EL_FILE_PATH)
		deferred
		end

feature {NONE} -- Event handling

	on_fail (base: ZSTRING)
		do
			Exception.raise_developer ("Could not save file as jpeg: %"%S%"", [base])
		end

feature {NONE} -- Internal attributes

	pixel_component: EV_ANY_I

feature {NONE} -- Constants

	Type_jpeg: STRING = "jpeg"

end

note
	description: "[
		Shared instance of ${EL_IMAGE_PATH_LOCATIONS} base on temporary installation `Package_dir'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-12-15 10:12:24 GMT (Sunday 15th December 2024)"
	revision: "5"

deferred class
	EL_SHARED_PACKAGE_IMAGES

inherit
	EL_ANY_SHARED

	EL_APPLICATION_CONSTANTS

	EL_SHARED_IMAGE_LOCATIONS

feature {NONE} -- Implementation

	package_images_scope: EL_OBJECT_SCOPE [EL_IMAGE_PATH_LOCATIONS]
		-- define scope replacing `Image' with `Package_images'
		do
			create Result.make (Image, Package_images)
		end

feature {NONE} -- Constants

	Package_images: EL_IMAGE_PATH_LOCATIONS
		-- installed location
		once
			create Result.make (Package_dir)
		end

end
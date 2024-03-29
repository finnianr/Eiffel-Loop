note
	description: "Shared access to instance of class ${EL_IMAGE_PATH_LOCATIONS}"
	notes: "[
		It is possible to temporarily change the image locations by copying a new
		instance of ${EL_IMAGE_PATH_LOCATIONS} on to **Image**.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "15"

deferred class
	EL_SHARED_IMAGE_LOCATIONS

inherit
	EL_ANY_SHARED

	EL_MODULE_DIRECTORY

feature {NONE} -- Constants

	Installation_images: EL_IMAGE_PATH_LOCATIONS
		-- installed location
		once
			create Result.make (Directory.Application_installation)
		end

	Image: EL_IMAGE_PATH_LOCATIONS
		-- image locations to be used by descendants of `EL_APPLICATION_PIXMAP'
		once
			create Result.make_default
			Result.copy (Installation_images)
		end

end
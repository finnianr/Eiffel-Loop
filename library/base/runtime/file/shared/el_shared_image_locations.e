note
	description: "Shared access to instance of class ${EL_IMAGE_PATH_LOCATIONS}"
	notes: "[
		Use class ${EL_OBJECT_SCOPE [ANY]} to temporarily change the image locations by copying a new
		instance of ${EL_IMAGE_PATH_LOCATIONS} on to **Image**. See class ${EL_SHARED_PACKAGE_IMAGES}
		as an example.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-12-10 11:51:10 GMT (Tuesday 10th December 2024)"
	revision: "16"

deferred class
	EL_SHARED_IMAGE_LOCATIONS

inherit
	EL_ANY_SHARED

	EL_MODULE_DIRECTORY

feature {NONE} -- Constants

	Image: EL_IMAGE_PATH_LOCATIONS
		-- image locations to be used by descendants of `EL_APPLICATION_PIXMAP'
		once
			create Result.make (Directory.Application_installation)
		end

end
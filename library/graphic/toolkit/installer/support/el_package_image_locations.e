note
	description: "Swap between installed images and images from unzipped installer package"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-22 13:25:10 GMT (Friday 22nd April 2022)"
	revision: "1"

deferred class
	EL_PACKAGE_IMAGE_LOCATIONS

inherit
	EL_ANY_SHARED

	EL_APPLICATION_CONSTANTS

	EL_SHARED_IMAGE_LOCATIONS

feature {NONE} -- Basic operations

	use_installed_images
		do
			Image.copy (Installation_image)
		end

	use_package_images
		do
			Image.copy (Package_image)
		end

feature {NONE} -- Constants

	Package_image: EL_IMAGE_PATH_LOCATIONS
		-- installed location
		once
			create Result.make (Package_dir)
		end
end
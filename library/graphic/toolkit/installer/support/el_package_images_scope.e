note
	description: "[
		Make images in unzipped install package globally available duing the scope
		of an across-loop, before reverting back to installed image locations.
	]"
	notes: "[
		To use: inherit from ${EL_SHARED_PACKAGE_IMAGES_SCOPE} and write a loop
		
			across Use_package_images as image loop
				-- call routines on objects descended from ${EL_APPLICATION_PIXMAP}
			end

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	EL_PACKAGE_IMAGES_SCOPE

inherit
	EL_ITERABLE_SCOPE [EL_IMAGE_PATH_LOCATIONS]

	EL_APPLICATION_CONSTANTS

	EL_SHARED_IMAGE_LOCATIONS

feature {NONE} -- Implementation

	new_item: EL_IMAGE_PATH_LOCATIONS
		do
			Result := Package_images
			Image.copy (Result) -- Make globally available
		end

	on_exit (item: EL_IMAGE_PATH_LOCATIONS)
		-- revert back to installed images on scope exit
		do
			Image.copy (Installation_images)
		end

feature {NONE} -- Constants

	Package_images: EL_IMAGE_PATH_LOCATIONS
		-- installed location
		once
			create Result.make (Package_dir)
		end
end
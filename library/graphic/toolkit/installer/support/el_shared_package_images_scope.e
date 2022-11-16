note
	description: "Shared instance of [$source EL_PACKAGE_IMAGES_SCOPE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

deferred class
	EL_SHARED_PACKAGE_IMAGES_SCOPE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Use_package_images: EL_PACKAGE_IMAGES_SCOPE
		-- across scope during which unzipped package images are used instead of
		-- installed images
		once
			create Result
		end
end
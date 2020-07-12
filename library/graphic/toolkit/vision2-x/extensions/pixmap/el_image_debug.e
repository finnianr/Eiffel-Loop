note
	description: "Facility to save image to desktop for debugging/inspection purposes"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-11 8:17:53 GMT (Saturday 11th July 2020)"
	revision: "1"

deferred class
	EL_IMAGE_DEBUG

inherit
	EL_MODULE_DIRECTORY

feature -- Basic operations

	save_to_desktop
		local
			base: ZSTRING
		do
			base := Name_template #$ [generator, width, height]
			base.to_lower
			save_as (Directory.desktop + base)
		end

feature {NONE} -- Implementation

	height: INTEGER
		deferred
		end

	save_as (a_file_path: EL_FILE_PATH)
		deferred
		end

	width: INTEGER
		deferred
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "%S.%Sx%S.png"
		end
end

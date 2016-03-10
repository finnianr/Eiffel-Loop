note
	description: "Build information"

	notes: "GENERATED FILE. Do not edit"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:03:51 GMT (Monday 24th June 2013)"
	revision: "3"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

create
	make

feature -- Constants

	Major_version: INTEGER = 1

	Minor_version: INTEGER = 8

	Build_number: INTEGER = 1

	Installation_sub_directory: EL_DIR_PATH
		once
			Result := "Eiffel-Loop"
		end

end

note
	description: "Build specification"

	notes: "GENERATED FILE. Do not edit"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-12-18 17:27:50 GMT (Sunday 18th December 2016)"
	revision: "1"

class
	BUILD_INFO

inherit
	EL_BUILD_INFO

feature -- Constants

	Version_number: NATURAL = 01_01_27

	Build_number: NATURAL = 366

	Installation_sub_directory: EL_DIR_PATH
		once
			create Result.make_from_unicode ("Eiffel-Loop/toolkit")
		end

end
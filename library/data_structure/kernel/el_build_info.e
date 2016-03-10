note
	description: "Summary description for {EL_BUILD_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:23:50 GMT (Tuesday 18th June 2013)"
	revision: "3"

deferred class
	EL_BUILD_INFO

inherit
	EL_MODULE_DIRECTORY

	EL_MODULE_STRING

feature {NONE} -- Initialization

	make
			--
		do
		end

feature -- Access

	short_version_string: STRING
		do
			Result := version_string.split (' ').first
		end

	version_string: STRING
			--
		do
			Result := String.template ("$S.$S ($S)").substituted (<< major_version, minor_version, build_number >>)
		end

	version_real: REAL
		do
			Result := ((major_version * 100 + minor_version) / 100).truncated_to_real
		end

	major_version: INTEGER
			--
		deferred
		end

	minor_version: INTEGER
			--
		deferred
		end

	build_number: INTEGER
			--
		deferred
		end

	installation_sub_directory: EL_DIR_PATH
			--
		deferred
		end

end

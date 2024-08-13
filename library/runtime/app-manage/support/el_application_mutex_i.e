note
	description: "Application mutex to create an application singleton"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-10 7:47:36 GMT (Saturday 10th August 2024)"
	revision: "12"

deferred class
	EL_APPLICATION_MUTEX_I

inherit
	EL_OS_DEPENDENT

	EL_MODULE_BUILD_INFO

	EL_CHARACTER_32_CONSTANTS

	EL_SHARED_SOFTWARE_VERSION

feature {NONE} -- Implementation

	make
		do
			make_default
			try_lock (new_mutex_name)
		end

	make_default
		deferred
		end

	make_for_application_mode (option_name: READABLE_STRING_GENERAL)
			-- Create mutex for application in mode specified by option_name
		do
			make_default
			try_lock (underscore.joined (new_mutex_name, option_name))
		end

feature -- Status change

	try_lock (name: ZSTRING)
		deferred
		end

	unlock
		require
			is_locked: is_locked
		deferred
		end

feature -- Status query

	is_locked: BOOLEAN
		-- Is this the only instance of this application

feature {NONE} -- Implementation

	new_mutex_name: ZSTRING
		-- eg. Hex_11_Software_My_Ching_1.2.9_mutex
		local
			characters: STRING; parts: ARRAY [ZSTRING]; s: EL_ZSTRING_ROUTINES
		do
			parts := << Build_info.installation_sub_directory, Software_version.string, "mutex" >>
			characters := "\/ "
			parts [1].translate (characters, underscore * characters.count)
			Result := s.joined_list (parts, '_')
		end
end
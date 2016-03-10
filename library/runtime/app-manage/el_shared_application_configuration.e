note
	description: "Summary description for {EL_SHARED_APPLICATION_CONFIGURATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-23 13:48:21 GMT (Sunday 23rd June 2013)"
	revision: "2"

deferred class
	EL_SHARED_APPLICATION_CONFIGURATION [G -> {EL_FILE_PERSISTENT} create make, make_from_file end]

feature -- Element change

	set_config (a_config: G)
		do
			configuration_cell.put (a_config)
		end

feature -- Access

	config: G
			--
		do
			Result := configuration_cell.item
		end

	stored_config: G
		do
			create Result.make_from_file (config.file_path)
		end

feature {NONE} -- Implementation

	configuration_cell: EL_APPLICATION_CONFIG_CELL [G]
			--
		deferred
		end

end

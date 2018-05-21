note
	description: "Shared application configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_SHARED_APPLICATION_CONFIGURATION [G -> {EL_FILE_PERSISTENT} create make_from_file end]

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
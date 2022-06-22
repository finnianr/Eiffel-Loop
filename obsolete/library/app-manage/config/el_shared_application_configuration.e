note
	description: "Shared application configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-20 12:14:18 GMT (Wednesday 20th February 2019)"
	revision: "7"

deferred class
	EL_SHARED_APPLICATION_CONFIGURATION [G -> {EL_FILE_PERSISTENT_I} create make_from_file end]

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

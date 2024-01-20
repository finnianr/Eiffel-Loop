note
	description: "[
		Normalizes location of implementation classes `(*_imp.e)' in relation to respective interfaces
		`(*_i.e)' for all projects referenced in repository publishing configuration. See class
		${CROSS_PLATFORM_CLUSTER} for details.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "9"

class
	IMP_CLASS_LOCATION_NORMALIZER

inherit
	REPOSITORY_PUBLISHER
		redefine
			execute, ecf_list
		end

	EL_APPLICATION_COMMAND

create
	make

feature -- Access

	Description: STRING = "Normalizes location of implementation classes in relation to respective interfaces"

	ecf_list: EIFFEL_CONFIGURATION_LIST [CROSS_PLATFORM_EIFFEL_CONFIGURATION_FILE]

feature -- Basic operations

	execute
		do
			ecf_list.do_all (agent {CROSS_PLATFORM_EIFFEL_CONFIGURATION_FILE}.normalize_imp_classes)
		end

end
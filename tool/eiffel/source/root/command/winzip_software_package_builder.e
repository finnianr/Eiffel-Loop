note
	description: "[
		Command to build an application and then package it as a self-extracting winzip exe installer.
	]"
	notes: "[
		Requires that the WinZip command-line utility `wzipse32' is installed and in the search path.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-19 15:49:38 GMT (Monday 19th October 2020)"
	revision: "1"

class
	WINZIP_SOFTWARE_PACKAGE_BUILDER

inherit
	EL_COMMAND

	EL_MODULE_DEFERRED_LOCALE

	WINZIP_SOFTWARE_COMMON

create
	make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (file_path: EL_FILE_PATH; architectures, targets: STRING)
		require
			valid_architectures: valid_architecture_list (architectures)
			valid_targets: valid_target_list (targets)
		do
			create config.make (file_path)
			create architecture_list.make (2)
			across architectures.split (',') as bit_count loop
				bit_count.item.left_adjust
				architecture_list.extend (bit_count.item.to_integer)
			end
			create target_list.make_with_csv (targets)
		end

	execute
		do
			across Locale.all_languages as lang loop
				build (Locale.in (lang.item))
			end
		end

	build (a_locale: EL_DEFERRED_LOCALE_I)
		local
			command: WINZIP_CREATE_SELF_EXTRACT_COMMAND
		do
			config.update (a_locale)
			create command.make (config)
			command.execute
		end

feature {NONE} -- Implementation: attributes

	config: PACKAGE_BUILDER_CONFIG

	architecture_list: ARRAYED_LIST [INTEGER]

	target_list: EL_STRING_8_LIST

end
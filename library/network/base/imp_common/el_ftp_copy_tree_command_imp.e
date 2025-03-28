note
	description: "[
		Implementation of ${EL_FTP_COPY_TREE_COMMAND_I} with the Unix [https://linux.die.net/man/1/lftp lftp command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 13:09:17 GMT (Friday 28th March 2025)"
	revision: "1"

class
	EL_FTP_COPY_TREE_COMMAND_IMP

inherit
	EL_FTP_COPY_TREE_COMMAND_I

	EL_OS_COMMAND_IMP

create
	make, make_backup, make_default

feature -- Access

	Template: STRING = "[
		lftp -c "open $host; user '$user' '$pass'; set ftp:passive-mode true;
		mirror --reverse --verbose '$source_path' '$destination_path';
		bye"
	]"

end
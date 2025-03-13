note
	description: "[
		Implementation of ${EL_RSYNC_COMMAND_I} with Unix [https://linux.die.net/man/1/rsync rsync command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-13 10:21:44 GMT (Thursday 13th March 2025)"
	revision: "14"

class
	EL_RSYNC_COMMAND_IMP

inherit
	EL_RSYNC_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			execute
		end

create
	make, make_ssh

feature -- Access

	Template: STRING = "[
		rsync	$enabled_options
		#if $has_exclusions then
			--exclude-from=$exclusions_path
		#end
		#if $user_domain.count > 0 then
			--rsh=ssh $source_path "$user_domain:$destination_path"
		#else
			$source_path $destination_path
		#end
	]"

end
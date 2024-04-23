note
	description: "[
		Implementation of ${EL_RSYNC_COMMAND_I} with Unix [https://linux.die.net/man/1/rsync rsync command]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-23 12:35:59 GMT (Tuesday 23rd April 2024)"
	revision: "13"

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
		rsync
		#if $archive_enabled then
			--archive
		#end
		#if $compress_enabled then
			--compress
		#end
		#if $delete_enabled then
			--delete
		#end
		#if $no_links_enabled then
			--no-links
		#end
		#if $progress_enabled then
			--progress
		#end
		#if $update_enabled then
			--update
		#end
		#if $verbose_enabled then
			--verbose
		#end
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
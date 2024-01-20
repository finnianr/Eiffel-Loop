note
	description: "Common implementation of ${EL_SSH_RSYNC_COMMAND_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "10"

class
	EL_SSH_RSYNC_COMMAND_IMP

inherit
	EL_SSH_RSYNC_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			execute
		end

create
	make

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
		#if $verbose_enabled then
			--verbose
		#end
		#if $has_exclusions then
			--exclude-from=$exclusions_path
		#end
		#if $user_domain.count > 0 then
			-e ssh $source_path "$user_domain:$destination_path"
		#else
			$source_path $destination_path
		#end
	]"

end
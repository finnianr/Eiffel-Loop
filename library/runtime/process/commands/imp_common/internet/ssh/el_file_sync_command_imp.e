note
	description: "Common implementation of [$source EL_SECURE_SHELL_FILE_SYNC_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-14 14:58:12 GMT (Tuesday 14th September 2021)"
	revision: "4"

class
	EL_FILE_SYNC_COMMAND_IMP

inherit
	EL_FILE_SYNC_COMMAND_I

	EL_OS_COMMAND_IMP

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
		#if $progress_enabled then
			--progress
		#end
		#if $verbose_enabled then
			--verbose
		#end
		#across $exclude_list as $list loop
			--exclude '$list.item'
		#end
		#if $user_domain.count > 0 then
			-e ssh $source_path "$user_domain:$destination_path"
		#else
			$source_path $destination_path
		#end
	]"

end
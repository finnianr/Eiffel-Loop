note
	description: "Common implementation of [$source EL_FILE_SYNC_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-28 12:46:49 GMT (Friday 28th January 2022)"
	revision: "7"

class
	EL_FILE_SYNC_COMMAND_IMP

inherit
	EL_FILE_SYNC_COMMAND_I

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
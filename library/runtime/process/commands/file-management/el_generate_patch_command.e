note
	description: "[
		Wrapper for Unix `bsdiff' command to generate a binary patch that can be applied with `bspatch'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-20 17:21:17 GMT (Friday 20th August 2021)"
	revision: "1"

class
	EL_GENERATE_PATCH_COMMAND

inherit
	EL_PARSED_OS_COMMAND [TUPLE [from_path, to_path, patch_path: STRING]]
		redefine
			execute, make_default
		end

create
	make

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create patch_path
			create to_path
		end

feature -- Access

	patch_path: EL_FILE_PATH

	to_path: EL_FILE_PATH

feature -- Basic operations

	execute
		local
			proportion: DOUBLE; size_patch_path: INTEGER
		do
			Precursor
			if not has_error and then patch_path.exists then
				size_patch_path := File_system.file_byte_count (patch_path)
				proportion := size_patch_path / File_system.file_byte_count (to_path)
				lio.put_labeled_string (patch_path.base + " proportion", (proportion * 100).rounded.out + "%%")
				lio.put_new_line
			end
		end

	send (ssh_copy_cmd: EL_SECURE_SHELL_COPY_COMMAND)
		-- send patch and checksum via secure shell
		require
			succucessful_execute: not has_error and then patch_path.exists
		local
			md5_cmd: EL_MD5_SUM_COMMAND; patch_sum_path: EL_FILE_PATH
			make_dir_cmd: EL_SECURE_SHELL_MAKE_DIRECTORY_COMMAND
		do
			create md5_cmd.make
			md5_cmd.set_target_path (to_path)
			md5_cmd.execute
			patch_sum_path := patch_path.with_new_extension ("md5sum")
			File_system.write_plain_text (patch_sum_path, md5_cmd.sum)
			lio.put_labeled_string ("Sending patch for ", to_path.base)
			lio.put_labeled_substitution (" to", "%S (%S)", [patch_path.base, md5_cmd.sum])
			lio.put_new_line

			create make_dir_cmd.make
			make_dir_cmd.set_user_domain (ssh_copy_cmd.user_domain)
			make_dir_cmd.set_target_dir (ssh_copy_cmd.destination_dir)
			make_dir_cmd.execute

			across << patch_path, patch_sum_path >> as path loop
				ssh_copy_cmd.set_source_path (path.item)
				ssh_copy_cmd.execute
			end
--			File_system.remove_file (patch_sum_path)
		end

feature -- Element change

	set_from_path (a_from_path: EL_FILE_PATH)
		do
			put_path (var.from_path, a_from_path)
		end

	set_patch_path (a_patch_path: EL_FILE_PATH)
		do
			patch_path := a_patch_path
			put_path (var.patch_path, a_patch_path)
		end

	set_to_path (a_to_path: EL_FILE_PATH)
		do
			to_path := a_to_path
			put_path (var.to_path, a_to_path)
		end

feature {NONE} -- Constants

	Template: STRING = "bsdiff $from_path $to_path $patch_path"
end
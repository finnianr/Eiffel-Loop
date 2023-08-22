note
	description: "FTP upload item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-22 18:06:38 GMT (Tuesday 22nd August 2023)"
	revision: "11"

class
	EL_FTP_UPLOAD_ITEM

inherit
	EL_MAKEABLE
		rename
			make as make_default
		end

create
	make, make_relative, make_default

feature {NONE} -- Initialization

	make (a_source_path: FILE_PATH; a_destination_dir: DIR_PATH)
		do
			source_path := a_source_path; destination_dir := a_destination_dir
		end

	make_default
		do
			create destination_dir
			create source_path
		end

	make_relative (a_source_path: FILE_PATH; source_root: DIR_PATH)
		require
			is_parent: source_root.is_parent_of (a_source_path)
		do
			make (a_source_path, a_source_path.relative_path (source_root).parent)
		end

feature -- Basic operations

	display (log: EL_LOGGABLE; verb: READABLE_STRING_GENERAL)
		do
			log.put_labeled_string (To #$ [verb, destination_dir], source_path.to_string)
			log.put_new_line
		end

feature -- Element change

	set_destination_dir (a_destination_dir: like destination_dir)
		do
			destination_dir := a_destination_dir
		end

	set_source_path (a_source_path: like source_path)
		do
			source_path := a_source_path
		end

feature -- Access

	destination_dir: DIR_PATH

	destination_file_path: FILE_PATH
		do
			Result := destination_dir + source_path.base
		end

	source_path: FILE_PATH

feature {NONE} -- Constants

	To: ZSTRING
		once
			Result := "%S to %S"
		end

end
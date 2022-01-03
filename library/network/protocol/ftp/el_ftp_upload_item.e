note
	description: "Ftp upload item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "8"

class
	EL_FTP_UPLOAD_ITEM

inherit
	ANY EL_MODULE_LIO

create
	make, make_default

feature {NONE} -- Initialization

	make (a_source_path: like source_path; a_destination_dir: DIR_PATH)
		do
			source_path := a_source_path; destination_dir := a_destination_dir
		end

	make_default
		do
			create destination_dir
			create source_path
		end

feature -- Basic operations

	display (verb: READABLE_STRING_GENERAL)
		do
			lio.put_path_field (verb, source_path); lio.put_path_field (" to", destination_dir)
			lio.put_new_line
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

	destination_file_path: FILE_PATH
		do
			Result := destination_dir + source_path.base
		end

	destination_dir: DIR_PATH

	source_path: FILE_PATH

end


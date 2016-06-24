note
	description: "Export HTML under www sub-directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-10 13:25:51 GMT (Friday 10th June 2016)"
	revision: "5"

class
	THUNDERBIRD_WWW_EXPORTER

inherit
	THUNDERBIRD_EXPORTER
		export
			{EL_SUB_APPLICATION} make
		end

	EL_COMMAND

	EL_MODULE_DIRECTORY
	EL_MODULE_FILE_SYSTEM

create
	default_create, make

feature -- Basic operations

	execute
		local
			converter: THUNDERBIRD_MAIL_TO_HTML_BODY_CONVERTER; file_path: EL_FILE_PATH
			output_dir: EL_DIR_PATH
		do
			log.enter ("execute")
			across File_system.file_list (mail_dir.joined_dir_path (WWW_dir_name), "*.msf") as path loop
				file_path := path.item.without_extension
				log.put_path_field ("Content", file_path)
				log.put_new_line
				output_dir := export_path.joined_dir_path (file_path.steps.last)
				File_system.make_directory (output_dir)
				create converter.make (output_dir)
				converter.convert_mails (file_path)
			end
			log.exit
		end

feature {NONE} -- Implementation


feature {NONE} -- Constants

	WWW_dir_name: ZSTRING
		once
			Result := "www.sbd"
		end

end

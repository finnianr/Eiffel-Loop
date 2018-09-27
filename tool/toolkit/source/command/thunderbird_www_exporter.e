note
	description: "Export HTML under www sub-directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-27 13:42:07 GMT (Thursday 27th September 2018)"
	revision: "6"

class
	THUNDERBIRD_WWW_EXPORTER

inherit
	EL_THUNDERBIRD_EXPORTER
		export
			{EL_SUB_APPLICATION} make
		undefine
			new_lio
		end

	EL_COMMAND

	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_OS

	EL_MODULE_LOG

create
	make

feature -- Basic operations

	execute
		local
			exporter: EL_THUNDERBIRD_EXPORT_AS_XHTML_BODY; file_path: EL_FILE_PATH
			output_dir: EL_DIR_PATH
		do
			log.enter ("execute")
			across OS.file_list (mail_dir.joined_dir_path (WWW_dir_name), "*.msf") as path loop
				file_path := path.item.without_extension
				log.put_path_field ("Content", file_path)
				log.put_new_line
				output_dir := export_path.joined_dir_path (file_path.base)
				create exporter.make (output_dir)
				exporter.export_mails (file_path)
			end
			log.exit
		end

feature {NONE} -- Constants

	WWW_dir_name: ZSTRING
		once
			Result := "www.sbd"
		end

end

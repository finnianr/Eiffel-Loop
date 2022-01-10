note
	description: "Export HTML under www sub-directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-10 16:46:45 GMT (Monday 10th January 2022)"
	revision: "11"

class
	THUNDERBIRD_WWW_EXPORTER

inherit
	EL_THUNDERBIRD_ACCOUNT_READER
		export
			{EL_COMMAND_CLIENT} make_from_file
		end

	EL_MODULE_LIO

create
	make_from_file

feature -- Basic operations

	execute
		local
			exporter: EL_THUNDERBIRD_WWW_XHTML_BODY_EXPORTER; file_path: FILE_PATH
			l_output_dir: DIR_PATH
		do
			across OS.file_list (mail_dir #+ WWW_dir_name, "*.msf") as path loop
				file_path := path.item.without_extension
				lio.put_path_field ("Content", file_path)
				lio.put_new_line
				l_output_dir := export_dir #+ file_path.base
				create exporter.make (Current)
				exporter.export_mails (file_path)
			end
		end

feature {NONE} -- Constants

	WWW_dir_name: ZSTRING
		once
			Result := "www.sbd"
		end

end

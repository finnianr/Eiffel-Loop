note
	description: "[
		Restore files from a backup made using the [http://duplicity.nongnu.org/ duplicity] utility
		and configured with a file in Pyxis format. See the notes section.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-02 10:59:25 GMT (Saturday 2nd March 2019)"
	revision: "4"

class
	DUPLICITY_RESTORE

inherit
	DUPLICITY_CONFIG
		redefine
			make_default
		end

	EL_COMMAND

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
		end

feature -- Basic operations

	 execute
		do
		end

feature {NONE} -- Implementation

feature {NONE} -- Internal attributes


feature {NONE} -- Constants


note
	notes: "[
		A typical configuration file is shown below. The configuration `name' is optional and defaults to
		the base of the `target_dir'. This name is used to name the backup directory name. All `exclude-files'
		entries are relative to the `target_dir'.

			pyxis-doc:
				version = 1.0; encoding = "UTF-8"

			duplicity:
				encryption_key = VAL; target_dir = "$HOME/dev/Eiffel/myching-server"; name = "My Ching server"
				destination:
					"file://$HOME/Backups/duplicity"
					"file:///media/finnian/Seagate-1/Backups/duplicity"
					"ftp://username@ftp.eiffel-loop.com/public/www/Backups/duplicity"
					"sftp://finnian@18.14.67.44/$HOME/Backups/duplicity"

				exclude-files:
					"""
						resources/locale.??
						www/images
					"""
				exclude-any:
					"""
						**/build
						**/workarea
						**/.sconf_temp
						**.a
						**.la
						**.lib
						**.obj
						**.o
						**.exe
						**.pyc
						**.evc
						**.dblite
						**.deps
						**.pdb
						**.zip
						**.tar.gz
						**.lnk
						**.goutputstream**
					"""

	]"

end

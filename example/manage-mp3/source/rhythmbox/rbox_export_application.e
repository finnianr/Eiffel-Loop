note
	description: "Summary description for {RBOX_EXPORT_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	RBOX_EXPORT_APPLICATION

inherit
	RBOX_APPLICATION
		redefine
			normal_initialize
		end

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			Precursor

			create id3_export
			id3_export.set_item (2.3)
			set_attribute_from_command_opt (id3_export, "id3_export", "id3 version to use for exporting operations")

			export_path := Directory.home.joined_dir_path ("Desktop/Music")
			set_attribute_from_command_opt (export_path, "destination", Destination_description)
		end

feature -- Basic operations

	normal_run
			--
		do
			create_database
			create device.make (export_path, database, id3_export)

			if database.is_initialized then
				do_export
			end
		end

	do_export
		deferred
		end

feature {NONE} -- Implementation

	device: MP3_DEVICE
		-- Export target device

	id3_export: REAL_REF

	export_path: EL_DIR_PATH

	destination_description: STRING
		deferred
		end

end

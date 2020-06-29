note
	description: "JPEG file interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-06-29 13:05:54 GMT (Monday 29th June 2020)"
	revision: "1"

deferred class
	EL_JPEG_PIXMAP_I

inherit
	EL_MEMORY
		redefine
			dispose
		end

	EL_MODULE_EXCEPTION

feature {NONE} -- Initialization

	make (a_pixel_buffer: POINTER; a_quality: INTEGER; owned: BOOLEAN)
		require
			percentage: 0 <= a_quality and a_quality <= 100
		do
			pixel_buffer := a_pixel_buffer; quality := a_quality; is_owned := owned
		end

feature -- Access

	quality: INTEGER

feature -- Basic operations

	save_as (a_file_path: EL_FILE_PATH)
		deferred
		end

feature {NONE} -- Disposal

	dispose
			-- Release memory pointed by `item'.
		local
			null: POINTER
		do
			if is_owned then
				free_buffer
			end
			pixel_buffer := null
			is_owned := False
		ensure then
			shared_reset: not is_owned
		end

	free_buffer
		deferred
		end

feature {NONE} -- Event handling

	on_fail (base: ZSTRING)
		do
			Exception.raise_developer ("Could not save file as jpeg: %"%S%"", [base])
		end

feature {NONE} -- Internal attributes

	is_owned: BOOLEAN
		-- `True' if `pixel_buffer' is owned

	pixel_buffer: POINTER

feature {NONE} -- Constants

	Type_jpeg: STRING = "jpeg"

invariant
	quality_is_percent: 0 <= quality and quality <= 100

end

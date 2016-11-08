note
	description: "Summary description for {EL_WEL_DISPLAY_MONITOR_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-10 9:03:52 GMT (Monday 10th October 2016)"
	revision: "3"

class
	EL_WEL_DISPLAY_MONITOR_INFO

inherit
	EL_WEL_DISPLAY_SIZE_INFO
		redefine
			default_create
		end

	EL_ALLOCATED_C_OBJECT
		undefine
			default_create
		end

	EL_WEL_DISPLAY_MONITOR_API
		undefine
			default_create
		end

	EL_MODULE_DIRECTORY
		undefine
			default_create
		end

	EL_MODULE_LIO
		undefine
			default_create
		end

	EL_MODULE_WIN_REGISTRY
		undefine
			default_create
		end

	EL_MODULE_REG_KEY
		undefine
			default_create
		end

	EL_WEL_CONVERSION
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		local
			monitor: POINTER
			point: WEL_POINT
		do
			create EDID.make (0)
			make_with_size (c_size_of_monitor_info_struct)
			cwin_set_struct_size (self_ptr, c_size_of_monitor_info_struct)

			create point.make (0, 0)
			monitor := cwin_primary_monitor_from_point (point.item)

			is_valid := cwin_get_monitor_info (monitor, self_ptr)
			if is_valid then
				set_primary_active_device
			end
			if is_valid then
				set_EDID_data
				if EDID.count > 0 and then model ~ EDID_model then
					set_width_and_height
				else
					is_valid := False
				end
			else
				is_valid := False
			end
			if is_lio_enabled then
				lio.put_double_field ("width cms", width_centimeters)
				lio.put_double_field (" height cms", height_centimeters)
				lio.put_new_line
			end
		end

feature -- Access

	name: STRING_32
			--
		local
			c_str: WEL_STRING
		do
			create c_str.make_by_pointer (cwin_get_device_name (self_ptr))
			Result := c_str.string
		end

	model: STRING
			-- Monitor model
			-- Example: IVM5601
		local
			path_steps: EL_PATH_STEPS
		do
			-- Example device_id: "MONITOR\IVM5601\{4d36e96e-e325-11ce-bfc1-08002be10318}\0000"
			path_steps := primary_device.device_id
			Result := path_steps.i_th (2)
		end

	primary_device: EL_WEL_DISPLAY_DEVICE

	EDID: MANAGED_POINTER
		-- Extended display identification data
		-- See: http://en.wikipedia.org/wiki/Extended_display_identification_data

feature -- Status query

	is_valid: BOOLEAN

feature {NONE} -- Implementation

	set_primary_active_device
			--
		local
			last_device_found, active_attached_found: BOOLEAN
			device_list: ARRAYED_LIST [EL_WEL_DISPLAY_DEVICE]
			device: EL_WEL_DISPLAY_DEVICE
		do
			create device_list.make (2)
			from until last_device_found loop
				create device.make (name, device_list.count)
				if device.is_valid then
					device_list.extend (device)
				else
					last_device_found := True
				end
			end
			from device_list.start until active_attached_found or device_list.after loop
				if device_list.item.is_active and device_list.item.is_attached then
					active_attached_found := True
					primary_device := device_list.item
				end
				device_list.forth
			end
			if active_attached_found then
				if primary_device.description.is_empty then
					create primary_device.make (name, 0)
					primary_device.set_description ("Default_Monitor")
				end
			else
				is_valid := False
			end
		end

	set_EDID_data
		require
			long_enough_device_id: primary_device.device_id.split ('\').count >= 2
		local
			EDID_registry_path: EL_DIR_PATH
		do
			if is_lio_enabled then
				lio.put_labeled_string ("Model", model)
				lio.put_new_line
			end
			across
				Win_registry.key_names (HKLM_enum_display.joined_dir_path (model)) as key
			until key.cursor_index > 1 loop
				EDID_registry_path := HKLM_enum_display.joined_dir_steps (<<
					model, key.item.name.to_string_8, "Device Parameters"
				>>)
			end
			EDID := Win_registry.data (EDID_registry_path, "EDID")
		ensure
			has_EDID_data: EDID.count > 0
		end

	set_width_and_height
		require
			model_agrees_with_model_in_EDID: model ~ EDID_model
		do
			width_centimeters := EDID.read_natural_8 (21)
			height_centimeters := EDID.read_natural_8 (22)
		end

	EDID_model: ZSTRING
		local
			byte1, byte2: NATURAL_16
			manufacturer_id: ARRAY [NATURAL_16]
			product_code: STRING
		do
			create manufacturer_id.make_filled (0, 1, 4)

			product_code := EDID.read_natural_16_le (10).to_hex_string

			byte1 := EDID.read_natural_8 (8)
			byte2 := EDID.read_natural_8 (9)

			manufacturer_id [1] := ((byte1 & 0x7C) |>> 2) + 64
			manufacturer_id [2] := ((byte1 & 3) |<< 3) + ((byte2 & 0xE0) |>> 5) + 64
			manufacturer_id [3] := (byte2 & 0x1F) + 64
			manufacturer_id [4] := 0

			Result := string16_to_string8 (manufacturer_id.area.base_address) + product_code
			if is_lio_enabled then
				lio.put_string_field ("EDID_model", Result)
				lio.put_new_line
			end
		end

feature {NONE} -- Constants

	HKLM_enum_display: EL_DIR_PATH
		once
			Result := Reg_key.current_control_set ("Enum\DISPLAY")
		end

end

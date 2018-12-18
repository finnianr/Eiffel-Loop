note
	description: "Console manager interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-26 10:05:08 GMT (Wednesday 26th September 2018)"
	revision: "7"

deferred class
	EL_CONSOLE_MANAGER_I

inherit
	EL_MODULE_ARGS

	EL_SINGLE_THREAD_ACCESS

feature {NONE} -- Initialization

	make
		do
			make_default
			create visible_types.make (20)
			no_highlighting_word_option_exists := Args.word_option_exists ({EL_COMMAND_OPTIONS}.no_highlighting)
		end

feature -- Status change

	hide (type: like visible_types.item)
			-- hide conditional `lio' output for type
			--	if {EL_MODULE_LIO}.is_lio_enabled then
			--		lio.put_xxx (xxx)
			--	end
		do
			restrict_access
				visible_types.remove (type)
			end_restriction
		end

	show (type: like visible_types.item)
			-- show conditional `lio' output for type
			--	if {EL_MODULE_LIO}.is_lio_enabled then
			--		lio.put_xxx (xxx)
			--	end
		do
			restrict_access
				visible_types.put (type)
			end_restriction
		end

	show_all (types: ARRAY [like visible_types.item])
			-- show conditional `lio' output for all types
			--	if {EL_MODULE_LIO}.is_lio_enabled then
			--		lio.put_xxx (xxx)
			--	end
		do
			restrict_access
				types.do_all (agent visible_types.put)
			end_restriction
		end

feature -- Status query

	is_highlighting_enabled: BOOLEAN
			-- Can terminal color highlighting sequences be output to console
		deferred
		end

	is_type_visible (type: like visible_types.item): BOOLEAN
			--
		do
			restrict_access
				Result := visible_types.has (type)
			end_restriction
		end

feature {NONE} -- Internal attributes

	no_highlighting_word_option_exists: BOOLEAN
		-- `True' if `no_highlighting' word option exists

	visible_types: EL_HASH_SET [TYPE [EL_MODULE_LIO]]
end
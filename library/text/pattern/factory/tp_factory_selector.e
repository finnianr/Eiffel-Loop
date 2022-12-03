note
	description: "Select core pattern factory by text type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 16:39:24 GMT (Saturday 3rd December 2022)"
	revision: "8"

deferred class
	TP_FACTORY_SELECTOR

inherit
	TP_SHARED_OPTIMIZED_FACTORY

feature {NONE} -- Implementation

	make_default
		do
			core := factory_general
		end

	set_optimal_core (text: READABLE_STRING_GENERAL)
		-- set `core' pattern factory with shared instance that is optimal for `text' type
		do
			if attached {ZSTRING} text then
				core := Factory_zstring

			elseif attached {READABLE_STRING_8} text then
				core := Factory_readable_string_8

			else
				core := factory_general
			end
		end

feature {NONE} -- Internal attributes

	core: TP_OPTIMIZED_FACTORY
		-- core pattern factory

end
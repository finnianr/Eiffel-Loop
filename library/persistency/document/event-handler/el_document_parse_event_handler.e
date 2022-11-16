note
	description: "Xml node event handler"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

deferred class
	EL_DOCUMENT_PARSE_EVENT_HANDLER

inherit
	EL_DOCUMENT_CLIENT

feature {EL_DOCUMENT_CLIENT} -- Parsing events

	on_start_document
			--
		deferred
		end

	on_end_document
			--
		deferred
		end

	on_start_tag (node: EL_DOCUMENT_NODE_STRING; attribute_list: EL_ELEMENT_ATTRIBUTE_LIST)
			--
		deferred
		end

	on_end_tag (node: EL_DOCUMENT_NODE_STRING)
			--
		deferred
		end

	on_content (node: EL_DOCUMENT_NODE_STRING)
			--
		deferred
		end

	on_comment (node: EL_DOCUMENT_NODE_STRING)
			--
		deferred
		end

	on_processing_instruction (node: EL_DOCUMENT_NODE_STRING)
			--
		deferred
		end
end
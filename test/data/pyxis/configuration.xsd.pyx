pyxis-doc:
	version = 1.0; encoding = "UTF-8"

xs.schema:
	xmlns.xs = "http://www.w3.org/2001/XMLSchema"
	targetNamespace = "http://www.eiffel.com/developers/xml/configuration-1-8-0"
	xmlns = "http://www.eiffel.com/developers/xml/configuration-1-8-0"
	elementFormDefault = qualified
	xs.element:
		name = system
		xs.complexType:
			xs.sequence:
				xs.element:
					name = note; type = note; minOccurs = 0; maxOccurs = unbounded
				xs.element:
					name = description; type = "xs:string"; minOccurs = 0
				xs.element:
					name = target; type = target; maxOccurs = unbounded
			xs.attribute:
				name = name; type = "xs:string"; use = required
			xs.attribute:
				name = uuid; type = uuid; use = optional
			xs.attribute:
				name = readonly; type = "xs:boolean"; use = optional
			xs.attribute:
				name = library_target; type = "xs:string"; use = optional
	xs.complexType:
		name = note
		xs.sequence:
			xs.any:
				minOccurs = 0; maxOccurs = unbounded; processContents = lax
		xs.anyAttribute:
			processContents = lax
	xs.simpleType:
		name = uuid
		xs.restriction:
			base = "xs:string"
			xs.pattern:
				value = "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}"
	xs.simpleType:
		name = location
		xs.restriction:
			base = "xs:string"

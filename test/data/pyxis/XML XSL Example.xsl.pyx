pyxis-doc:
	version = 1.0; encoding = "UTF-8"

xsl.stylesheet:
	version = 1.0; xmlns.xsl = "http://www.w3.org/1999/XSL/Transform"
	xsl.template:
		match = "/"
		html:
			head:
				title:
					"XML XSL Example"
				style:
					type = "text/css"
					"""
						body
						{
						margin:10px;
						background-color:#ccff00;
						font-family:verdana,helvetica,sans-serif;
						}
						
						.tutorial-name
						{
						display:block;
						font-weight:bold;
						}
						
						.tutorial-url
						{
						display:block;
						color:#636363;
						font-size:small;
						font-style:italic;
						}
					"""
			body:
				h2:
					"Cool Tutorials"
				p:
					"Hey, check out these tutorials! Tagebücher"
				xsl.apply-templates:
	xsl.template:
		match = tutorial
		span:
			class = tutorial-name
			xsl.value-of:
				select = name
		span:
			class = tutorial-url
			xsl.value-of:
				select = url

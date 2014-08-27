<?xml version="1.0" encoding="UTF-8"?>
<!--
	XSLT to extract a CDA payload from an instance wrapped with HL7 wrappers (i.e. an interaction example)
		v0.1 - 24/02/2012 - David McGuffin (Applied Informatics Ltd) - Initial Draft
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:v3="urn:hl7-org:v3" >
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<xsl:copy-of select="//v3:ClinicalDocument"/>
	</xsl:template>
</xsl:stylesheet>
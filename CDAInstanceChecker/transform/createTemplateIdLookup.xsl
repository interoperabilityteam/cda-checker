<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:mif="urn:hl7-org:v3/mif">
<xsl:output method="xml" indent="yes" name="xml"/>
	<xsl:template match="/">
	<xsl:variable name="docList" as="node()*" select="collection(iri-to-uri('../mif/?select=*.mif;on-error=warning'))"/>
	<xsl:variable name="filename" select="concat('..\schematron\','TemplateIDLookUp.xml')"/>
	<xsl:result-document href="{$filename}" format="xml">
	<TemplateIdLookUp>
		<xsl:for-each select="$docList">
			<xsl:variable name="templateName" select="mif:staticModel/mif:ownedEntryPoint/@name"/>
			<xsl:variable name="templateId" select="mif:staticModel/mif:ownedEntryPoint/@id"/>
				<xsl:element name="Template">
					<xsl:copy-of select="$templateId"/>
					<xsl:copy-of select="$templateName"/>
						<xsl:for-each select="mif:staticModel/mif:ownedClass">
							<xsl:variable name="className" select="mif:class/@name"/>
							<xsl:variable name="templateid" select="mif:class/mif:attribute[@name='templateId']/@fixedValue"/>
							<xsl:if test="count($templateId) &gt; 0">
								<xsl:element name="templateId">
									<xsl:copy-of select="$className"/>
									<xsl:copy-of select="$templateid"/>		
								</xsl:element>
							</xsl:if>	
					</xsl:for-each>	
				</xsl:element>	
		</xsl:for-each>
	</TemplateIdLookUp>
	</xsl:result-document>	
	</xsl:template>
</xsl:stylesheet>

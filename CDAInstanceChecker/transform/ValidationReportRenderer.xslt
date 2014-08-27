<?xml version="1.0" encoding="UTF-8"?>
<!--
	XSLT to render a CDAInstanceChecker XML validation report as HTML
		v0.1 - 23/02/2012 - David McGuffin (Applied Informatics Ltd) - Initial Draft
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="html" encoding="UTF-8" indent="yes" />
	
	<xsl:variable name="reportType">
		<xsl:choose>
			<xsl:when test="contains(validationReport/cdaInstance[1]/@xml, 'input')">On-the-Wire</xsl:when>
			<xsl:otherwise>Templated</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="timeStamp">
		<xsl:value-of select="validationReport/@timeStamp"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:copy-of select="$reportType"/><xsl:text> CDA Instance Validation Report - </xsl:text><xsl:copy-of select="$timeStamp"/>
				</title>
			</head>
			<body style="font-family:arial;">
				<h1>
					<xsl:copy-of select="$reportType"/><xsl:text> CDA Instance Validation Report: </xsl:text><xsl:copy-of select="$timeStamp"/>
				</h1>
				<table width="100%" align="left" border="0">
					<tr>
						<td>
							<b style="font-size:11px;"><u><i>Legend:</i></u></b>
							<br/>
							<table width="40%" align="left" border="0" cellspacing="1" style="font-size:11px;">
								<tr>
									<td width="1%"/>
									<td width="10%" style="background-color:green;"/>
									<td width="1%"/>
									<td width="88%">No validation errors or warnings found</td>
								</tr>
								<tr>
									<td/>
									<td style="background-color:red;"/>
									<td/>
									<td>Validation errors present (warnings may also be present)</td>
								</tr>
								<tr>
									<td/>
									<td style="background-color:orange;"/>
									<td/>
									<td>Validation warnings present (no errors found)</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td><hr align="left" width="95%"/></td>
					</tr>
					<tr>
						<td>
							<table width="90%" border="1px" style="border-collapse:collapse;">
								<xsl:for-each select="validationReport/cdaInstance">
									<xsl:choose>
										<xsl:when test="schemaValidationError, schematronFailureAssertion, schematronSuccessfulReport">
											<xsl:choose>
												<xsl:when test="schemaValidationError, schematronFailureAssertion">
													<tr style="background-color:red;">
														<th align="left" colspan="2"><xsl:value-of select="@xml"/></th>
													</tr>
												</xsl:when>
												<xsl:otherwise>
													<tr style="background-color:orange;">
														<th align="left" colspan="2"><xsl:value-of select="@xml"/></th>
													</tr>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:for-each select="schemaValidationError">
												<tr style="font-size:14px;">
													<td width="15%"><xsl:text>Schema Validation Error</xsl:text></td>
													<td width="85%">
														<xsl:text>Line </xsl:text><xsl:value-of select="@lineNumber"/>
														<xsl:text> Column </xsl:text><xsl:value-of select="@columnNumber"/>
														<xsl:text>:</xsl:text><br/><i><xsl:value-of select="."/></i>
													</td>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="schematronFailureAssertion">
												<tr style="font-size:14px;">
													<td width="15%"><xsl:text>Schematron Assertion Failure</xsl:text></td>
													<td width="85%">
														<xsl:text>Test: </xsl:text><xsl:value-of select="@test"/>
														<br/><i><xsl:value-of select="."/></i>
													</td>
												</tr>
											</xsl:for-each>
											<xsl:for-each select="schematronSuccessfulReport">
												<tr style="font-size:14px; color:blue;">
													<td width="15%"><xsl:text>Schematron Report</xsl:text></td>
													<td width="85%">
														<xsl:text>Test: </xsl:text><xsl:value-of select="@test"/>
														<br/><i><xsl:value-of select="."/></i>
													</td>
												</tr>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<tr style="background-color:green;">
												<th align="left" colspan="2"><xsl:value-of select="@xml"/></th>
											</tr>
											<tr style="font-size:14px;">
												<td width="15%"><xsl:text>Valid</xsl:text></td>
												<td width="85%">ok</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</table>
						</td>	
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>
	
</xsl:stylesheet>

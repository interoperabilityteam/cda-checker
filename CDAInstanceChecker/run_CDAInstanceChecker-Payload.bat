REM: **************************************************************
REM: run_CDAInstanceChecker-Payload.bat
REM:   v0.1 - 16-02-2012 - David McGuffin (Applied Informatics Ltd) - Initial draft
REM:   v0.2 - 23-02-2012 - David McGuffin (Applied Informatics Ltd) - Updated with revised naming convention for directories and variables
REM:   v0.3 - 16-04-2012 - Interoperability Team - Added step to create TemplateLookupId.xml
REM: **************************************************************
REM:
REM:
REM: Set the values of the variables to be used within this batch file.
REM:   Note: Paths can be absolute or relative. Relative paths must be relative to the location of this batch file.
REM: 
REM:   Variables used are:
REM:     - input_mif - directory where all mif files are copied from domain message specification
REM:     - xsl_templatelookup - XSLT file used to create TemplateIdLookup.xml
REM:     - output_templatelookup - directory where TemplateIdLookup.xml file is created.
REM:     - input_payload - directory of on-the-wire CDA instances to be used as input for the CDA Instance Checker
REM:     - output_templated - directory where templated CDA instances will be written following transformation
REM:     - schematron_otw - schematron validating stylesheet to be applied to each on-the-wire instance
REM:     - schematron_templated - schematron validating stylesheet to be applied to each templated instance
REM:     - xsl_transform - XSLT file to use to transform on-the-wire instance to templated instance
REM:     - xsl_render - XSLT file to use to render the validation report as HTML
REM:     - report_xml_otw - on-the-wire instances XML validation report to be produced by the CDA Instance Checker
REM:     - report_xml_templated - templated instances XML validation report to be produced by the CDA Instance Checker
REM:     - report_html_otw - on-the-wire instances HTML validation report to be produced by the CDA Instance Checker
REM:     - report_html_templated - templated instances HTML validation report to be produced by the CDA Instance Checker
REM:     - log - log file maintained by the CDA Instance Checker
REM:     - schema_otw - XML schema to be explicitly applied to each on-the-wire instance. If this variable has a value of "null" then the CDA Instance Checker will assume that a schemaLocation attribute is present within the root element of each CDA instance
REM:     - schema_templated - XML schema to be explicitly applied to each templated instance. If this variable has a value of "null" then the CDA Instance Checker will assume that a schemaLocation attribute is present within the root element of each CDA instance
REM:

set input_mif=mif
set xsl_templatelookup=transform\createTemplateIdLookup.xsl
set output_templatelookup=schematron
set input_payload=input\input_payload
set output_templated=output\output_templated
set schematron_otw=schematron\Generic_CDA_Document_Schematron.xsl
set schematron_templated=schematron\Templated_CDA_Document_Schematron.xsl
set xsl_transform=transform\TrueCDAToCDALike_v2.xsl
set xsl_render=transform\ValidationReportRenderer.xslt
set report_xml_otw=report\ValidationReport_OnTheWireCDAInstances.xml
set report_xml_templated=report\ValidationReport_TemplatedCDAInstances.xml
set report_html_otw=report\ValidationReport_OnTheWireCDAInstances.html
set report_html_templated=report\ValidationReport_TemplatedCDAInstances.html
set log=log\CDAInstanceChecker.log
set schema_otw=null
set schema_templated=null


REM: Run the CDA Instance Checker. This involves the following processes:
REM:   0. STEP 0 - Transform to create TemplateIDLookup.xml from the available mif files in the domain
REM:   1. Step 1 - Check the on-the-wire instances for validity against the XML Schema and Schematron
REM:   2. Step 2 - Transform the on-the-wire instances to templated instances
REM:   3. Step 3 - Check the newly created templated instances for validity against the XML Schema and Schematron
REM:   4. Step 4 - Transform the validation reports to HTML
REM:   5. Step 5 - Open the HTML validation reports
REM: 
REM: All standard and error stream output is written to %log%
REM:

ECHO. >>%log%
ECHO %date%, %time%: CDA Instance Checker - Payload >>%log%
ECHO ========================================================= >>%log%


ECHO Cleaning up prior to running tool... >>%log%
DEL /Q %output_templated%


ECHO. >>%log%

ECHO STEP 0: Transform to create TemplateIDLookup.xml from the available mif files in the domain >>%log%
  java -classpath lib\saxonhe9-3-0-5j\saxon9he.jar net.sf.saxon.Transform -s:%input_mif% -xsl:%xsl_templatelookup% -o:%output_templatelookup% 1>>%log% 2>&1


ECHO. >>%log%

ECHO STEP 1: Check the on-the-wire instances for validity against the XML Schema and Schematron >>%log%
  IF %schema_otw%==null (
    java -classpath lib\xerces-2_9_0\xercesImpl.jar;lib\cdaInstanceChecker-1_0\cdaInstanceChecker.jar org.net.nhs.hl7.cdaInstanceChecker.CDAInstanceChecker %input_payload% %report_xml_otw% %schematron_otw% 1>>%log% 2>&1
  ) ELSE (
    java -classpath lib\xerces-2_9_0\xercesImpl.jar;lib\cdaInstanceChecker-1_0\cdaInstanceChecker.jar org.net.nhs.hl7.cdaInstanceChecker.CDAInstanceChecker %input_payload% %report_xml_otw% %schematron_otw% %schema_otw% 1>>%log% 2>&1
  )


ECHO. >>%log%


ECHO STEP 2: Transform the on-the-wire instances to templated instances >>%log%
  java -classpath lib\saxonhe9-3-0-5j\saxon9he.jar net.sf.saxon.Transform -s:%input_payload% -xsl:%xsl_transform% -o:%output_templated% 1>>%log% 2>&1


ECHO. >>%log%


ECHO STEP 3: Check the newly created templated instances for validity against the XML Schema and Schematron >>%log%
  IF %schema_templated%==null (
    java -classpath lib\xerces-2_9_0\xercesImpl.jar;lib\cdaInstanceChecker-1_0\cdaInstanceChecker.jar org.net.nhs.hl7.cdaInstanceChecker.CDAInstanceChecker %output_templated% %report_xml_templated% %schematron_templated% 1>>%log% 2>&1
  ) ELSE (
    java -classpath lib\xerces-2_9_0\xercesImpl.jar;lib\cdaInstanceChecker-1_0\cdaInstanceChecker.jar org.net.nhs.hl7.cdaInstanceChecker.CDAInstanceChecker %output_templated% %report_xml_templated% %schematron_templated% %schema_templated% 1>>%log% 2>&1
  )


ECHO. >>%log%


ECHO STEP 4: Transform the validation reports to HTML >>%log%
  java -classpath lib\saxonhe9-3-0-5j\saxon9he.jar net.sf.saxon.Transform -s:%report_xml_otw% -xsl:%xsl_render% -o:%report_html_otw% 1>>%log% 2>&1
  java -classpath lib\saxonhe9-3-0-5j\saxon9he.jar net.sf.saxon.Transform -s:%report_xml_templated% -xsl:%xsl_render% -o:%report_html_templated% 1>>%log% 2>&1


ECHO. >>%log%


ECHO STEP 5: Open the HTML validation reports >>%log%
  start %report_html_otw% 1>>%log% 2>&1
  start %report_html_templated% 1>>%log% 2>&1
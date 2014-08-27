REM: **************************************************************
REM: run_CDAInstanceChecker-Renderer.bat
REM: v0.1 - 27-02-2012 - David McGuffin (Applied Informatics Ltd) - Initial draft
REM: v0.2 - 05-04-2013 - Interoperability Team
REM: **************************************************************
REM:
REM:
REM: Set the values of the variables to be used within this batch file.
REM:   Note: Paths can be absolute or relative. Relative paths must be relative to the location of this batch file.
REM: 
REM:   Variables used are:
REM:     - input - directory of on-the-wire CDA instances to be rendered as HTML
REM:     - output - directory where rendered CDA instances will be written following application of the rendering tansform
REM:     - xsl - XSLT file to use to render the on-the-wire CDA instances as HTML
REM:     - log - log file maintained by the CDA Instance Checker
REM:


set input=input\input_payload
set output=output\output_rendered
set xsl=transform\nhs_CDA_Document_Renderer.xsl
set log=log\CDAInstanceChecker.log


REM: Run the CDA Instance Checker Renderer. This involves the following processes:
REM:   1. Step 1 - Render the on-the-wire payload instances as HTML
REM: 
REM: All standard and error stream output is written to %log%
REM:

ECHO. >>%log%
ECHO %date%, %time%: CDA Instance Checker - Renderer >>%log%
ECHO ========================================================== >>%log%


ECHO Cleaning up prior to running tool... >>%log%
DEL /Q %output%


ECHO. >>%log%


ECHO STEP 1: Render the on-the-wire CDA instances as HTML >>%log%
java -classpath lib\saxonhe9-3-0-5j\saxon9he.jar net.sf.saxon.Transform -s:%input% -xsl:%xsl% -o:%output%  1>>%log% 2>&1
REN %output%\*.xml *.html 1>>%log% 2>&1

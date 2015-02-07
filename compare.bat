@echo off
:main
::
:: Get the variables from the config file
::
for /f "delims=" %%x in (config.txt) do (set "%%x")
echo CONFIGS______________________________
echo %services%
echo %operations%
echo %pathFile%
echo %url%
echo %uri%
echo CONFIGS______________________________

::
:: Get the files from the directory
::
::for %%c in (%services%) do (
::	for %%d in (%operations%) do (
::	  echo.
::echo SERVICE: %%c
::echo OPERATION %%d path %pathFile%\%services%\%%d\request
::echo FILES BEGIN
		
for %%a in (%services%) do (
  echo %%a
	for %%b in (%operations%) do (
		set result = "PASS"
		echo %%b
		mkdir %%a\%%b\output
::	Checks if the directory that is in the config file is present on windows 
		IF EXIST %pathFile%\%%a\%%b\request (
			pushd %pathFile%\%%a\%%b\request
::		Loops to get file names. 
			for /f "delims=" %%f in ('dir /b /a-d-h-s') do (
::				echo HERE IS THE FILENAME WITHOUT EXTENSION:: %%~nf
				echo.
				echo START CURL
				curl -k --header "Content-Type: text/xml;charset=UTF-8"  -d @%pathFile%\%%a\%%b\request\%%~nf.txt %url%:%uri% -o %pathFile%\%%a\%%b\output\%%~nf_out.txt
				echo curl -k --v --header "Content-Type: text/xml;charset=UTF-8"  -d @%pathFile%\%%a\%%b\request\%%~nf.txt %url%:%uri% -o %pathFile%\%%a\%%b\output\%%~nf_out.txt
				echo END CURL
				echo.
				fc /W %pathFile%\%%a\%%b\response\%%~nf_response.txt %pathFile%\%%a\%%b\output\%%~nf_out.txt > nul
				if errorlevel 1 (
					@echo %date%:%%a\%%b\request\%%~nf_request.txt - FAIL >> %pathFile%\log.txt
					echo FAIL
				) else (
					@echo %date%:%%a\%%b\%%~nf_request.txt - PASS >> %pathFile%\log.txt
					echo PASS PASS  PASS PASS PASS PASS PASS v PASS PASS PASS PASS PASS PASS PASS PASS PASS PASS PASS PASS PASS PASS
				)
			)	
			echo END of %%a:%%b
			echo.
			popd
		) ELSE (
				echo ERROR: Directory %pathFile%\%%c\%%d does not exist.
			  echo END of %%a:%%b 
			  echo.
				popd
		)
	)
)


:end
endlocal
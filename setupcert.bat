@echo off
mode 130,80
rem script to create certificate for SSL in scope of Tomcat/Java
rem http://www.sslshopper.com/article-most-common-java-keytool-keystore-commands.html
rem http://www.sslshopper.com/article-how-to-create-a-self-signed-certificate-using-java-keytool.html

set alias=selfsigned
set jksfile=keystore.jks
set cerfile=server.cer
set cacerts=C:\Program Files (x86)\Java\jdk1.7.0_25\jre\lib\security\cacerts
set pass=changeit

rem First fo all delete existed alias, if it was created previously
keytool -delete -v -storepass %pass% -keystore "%cacerts%" -alias %alias%

rem Generate keystore.js if you need other date to change in cert.
rem keytool -genkeypair -keypass %pass% -storepass %pass% -alias %alias% -keyalg RSA -keystore %jksfile% -keysize 2048
rem Instead of generating new jks file, we may use existed (./keystore.js).

rem Check if jks file ok
keytool -list -v -storepass %pass% -keystore %jksfile% 

rem Export from jks into cer file
keytool -export -keypass %pass% -storepass %pass% -alias %alias% -file %cerfile% -keystore %jksfile%

rem Import cer file into cacerts
keytool -import -keypass %pass% -storepass %pass% -alias %alias% -v -trustcacerts -noprompt -file %cerfile% -keystore "C:\Program Files (x86)\Java\jdk1.7.0_25\jre\lib\security\cacerts" 

rem check if cacerts ok
keytool -list -v -storepass %pass% -alias %alias% -keystore "%cacerts%" 

rem Now we need to copy to %USERPROFILE% because keystore property in  server.xml configured to this path: C:/Users/%USERPROFILE%/keystore.jks
xcopy %jksfile% %USERPROFILE% /Y /F

pause



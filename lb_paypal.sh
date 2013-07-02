#!/bin/bash

GROUP_ID='paypal';
VERSION='1.0.0'

mvn install:install-file -DgroupId=$GROUP_ID -DartifactId=paypal_platform_base_AP -Dversion=$VERSION -Dpackaging=jar -Dfile=lib/paypal_platform_base_AP.jar

mvn install:install-file -DgroupId=$GROUP_ID -DartifactId=paypal_platform_base_src_AP -Dversion=$VERSION -Dpackaging=jar -Dfile=lib/paypal_platform_base_src_AP.jar

mvn install:install-file -DgroupId=$GROUP_ID -DartifactId=paypal_platform_stubs_AP -Dversion=$VERSION -Dpackaging=jar -Dfile=lib/paypal_platform_stubs_AP.jar

mvn install:install-file -DgroupId=$GROUP_ID -DartifactId=paypal_platform_stubs_src_AP -Dversion=$VERSION -Dpackaging=jar -Dfile=lib/paypal_platform_stubs_src_AP.jar


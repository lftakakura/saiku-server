#!/usr/bin/env bash

env

# base LDAP server URL
sed -i s/"CONTEXT_SOURCE_PROVIDER_URL"/"$CONTEXT_SOURCE_PROVIDER_URL"/g saiku-server/tomcat/webapps/saiku/WEB-INF/applicationContext-security-ldap.properties

# userDn to bind
sed -i s/"CONTEXT_SOURCE_USER_DN"/"$CONTEXT_SOURCE_USER_DN"/g saiku-server/tomcat/webapps/saiku/WEB-INF/applicationContext-security-ldap.properties

# userDn password
sed -i s/"CONTEXT_SOURCE_PASSWORD"/"$CONTEXT_SOURCE_PASSWORD"/g saiku-server/tomcat/webapps/saiku/WEB-INF/applicationContext-security-ldap.properties

# user search base path
sed -i s/"USER_SEARCH_SEARCH_BASE"/"$USER_SEARCH_SEARCH_BASE"/g saiku-server/tomcat/webapps/saiku/WEB-INF/applicationContext-security-ldap.properties

# user search filter
sed -i s/"USER_SEARCH_SEARCH_FILTER"/"$USER_SEARCH_SEARCH_FILTER"/g saiku-server/tomcat/webapps/saiku/WEB-INF/applicationContext-security-ldap.properties

# Populator
sed -i s/"POPULATOR_GROUP_ROLE_ATTRIBUTE"/"$POPULATOR_GROUP_ROLE_ATTRIBUTE"/g saiku-server/tomcat/webapps/saiku/WEB-INF/applicationContext-security-ldap.properties

sed -i s/"POPULATOR_GROUP_SEARCH_BASE"/"$POPULATOR_GROUP_SEARCH_BASE"/g saiku-server/tomcat/webapps/saiku/WEB-INF/applicationContext-security-ldap.properties

sed -i s/"POPULATOR_GROUP_SEARCH_FILTER"/"$POPULATOR_GROUP_SEARCH_FILTER"/g saiku-server/tomcat/webapps/saiku/WEB-INF/applicationContext-security-ldap.properties

# Define admin role
sed -i s/"ROLE_ADMIN"/"$ROLE_ADMIN"/g saiku-server/tomcat/webapps/saiku/WEB-INF/saiku-beans.xml

# LDAP server address
sed -i s/"SSAS_SERVER"/"$SSAS_SERVER"/g saiku-server/tomcat/webapps/saiku/WEB-INF/classes/legacy-datasources/ssas


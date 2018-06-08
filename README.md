
# Saiku Server  
  
Saiku allows business users to explore complex data sources, using a familiar drag and drop interface and easy to understand business terminology, all within a browser. Select the data you are interested in, look at it from different perspectives, drill into the detail. Once you have your answer, save your results, share them, export them to Excel or PDF, all straight from the browser. 

This project is based on [Meteorite BI's saiku-server](https://github.com/OSBI/saiku/tree/development/saiku-server) with a small change on file **saiku-server/tomcat/webapps/saiku/WEB-INF/applicationContext-security-ldap.properties** to make it easier to configure ldap on Docker.

## Docker  
  To deploy Saiku server with docker, a Dockerfile is provided. The server runs on port 8080 (change it on **saiku-server/tomcat/conf/server.xml**).  
  Just build it and do a **docker run**:  
  
Example  
```bash  
docker build -t saiku-server  
  
docker run -p 8080:8080 \  
-e CONTEXT_SOURCE_PROVIDER_URL="LDAP_SERVER\:389\/dc\=PLACEHOLDER\,dc\=PLACEHOLDER" \  
-e CONTEXT_SOURCE_USER_DN=USERNAME@domain.com.br \  
-e CONTEXT_SOURCE_PASSWORD=PASSWORD \  
-e USER_SEARCH_SEARCH_BASE= \  
-e USER_SEARCH_SEARCH_FILTER=userPrincipalName \  
-e SSAS_SERVER="http\:\/\/SSAS_SERVER\/msmdpump.dll" \  
-e POPULATOR_GROUP_ROLE_ATTRIBUTE=name \  
-e POPULATOR_GROUP_SEARCH_BASE="CN=GROUP_NAME,OU=PLACEHOLDER,OU=PLACEHOLDER" \  
-e POPULATOR_GROUP_SEARCH_FILTER="member={0}" \  
-e ROLE_ADMIN="GROUP_NAME" \  
saiku-server  
```


For volume persistence, copy the folder saiku_volume and add the flag
```bash
-v /path/to/saiku_volume/:/root/saiku-server/repository/


**Don't forget to break the reserved chars when filling the env vars above, otherwise the script configure_ldap.sh will not execute correctly!**

## Configuration (non docker)  
  
#### Authentication
It is prepared to authenticate both on **jdbc** (default) and **ldap**. To switch between the two methods, edit the file **saiku-server/tomcat/webapps/saiku/WEB-INF/applicationContext-spring-security** changing the `<import>` tag inside `<beans></beans>`:  
  
   # jdbc  
    <import resource="applicationContext-spring-security-jdbc.xml"/>  
  
    # ldap  
    <import resource="applicationContext-spring-security-ldap.xml"/>  
  
 #### Ldap configuration  
 When using ldap authentication edit the file **saiku-server/tomcat/webapps/saiku/WEB-INF/applicationContext-security-ldap.properties**:  
  
    contextSource.providerUrl=ldap\://CONTEXT_SOURCE_PROVIDER_URL  
    contextSource.userDn=CONTEXT_SOURCE_USER_DN  
    contextSource.password=CONTEXT_SOURCE_PASSWORD  
    userSearch.searchBase=USER_SEARCH_SEARCH_BASE  
    userSearch.searchFilter=(USER_SEARCH_SEARCH_FILTER={0})  
    populator.convertToUpperCase=false  
    populator.groupRoleAttribute=POPULATOR_GROUP_ROLE_ATTRIBUTE  
    populator.groupSearchBase=POPULATOR_GROUP_SEARCH_BASE  
    populator.groupSearchFilter=POPULATOR_GROUP_SEARCH_FILTER  
    populator.rolePrefix=  
  
|Property  | Details | Example  
|--|--|--|  
| contextSource.providerUrl | The IP or domain name of the Ldap to connect on with port and base dn | ldap\://192.168.0.0\:389/dc=stone,dc=local  
| contextSource.userDn | Ldap user dn with permissions to list all other users | ltakakura@stone.com.br  
| contextSource.password | Ldap user password | 123456  
| userSearch.searchBase | User search base path on ldap | dc=Users  
| userSearch.searchFilter | Ldap user field to search users on when performing authentication | userPrincipalName,  
| populator.convertToUpperCase | Convert the group role to uppercase | false  
| populator.groupRoleAttribute | The field whose value will be granted admin level permission | name  
| populator.groupSearchBase | Group search base path on ldap | CN=Rexlab | Stone,OU=Groups,OU=Risk,OU=SP  
| populator.groupSearchFilter | Ldap group field to search users on when performing authentication. {0} uses the full user_dn that is authenticating and {1} uses only its username | member={0}  
| populator.rolePrefix | Adds a prefix to the group role value | ADMIN_  
  
After defining which group will receive admin permissions, edit **saiku-server/tomcat/webapps/saiku/WEB-INF/saiku-beans.xml**:  
  
    <bean id="userServiceBean" class="org.saiku.service.user.UserService">  
       <property name="jdbcUserDAO" ref="userDAO"/>  
       <property name="datasourceService" ref="datasourceServiceBean"/>  
       <property name="iDatasourceManager" ref="repositoryDsManager"/>  
       <property name="adminRoles">  
          <list>  
             <value>ROLE_ADMIN</value>  
          </list>  
       </property>  
       <property name="sessionService" ref="sessionService"/>  
    </bean>  
Change **ROLE_ADMIN** by the value of **populator.groupRoleAttribute** from the group to receive admin permissions.  
  
* More about LDAP spring security on https://docs.spring.io/spring-security/site/docs/3.0.x/reference/ldap.html  
  
 #### SSAS Datasource configuration  
 On **saiku-server/tomcat/webapps/saiku/WEB-INF/classes/legacy-datasources/ssas** SSAS datasource template can be found. It is on passthrough mode, so the login credentials used on Saiku will also be used to authenticate on the Datasource. Find **SSAS_SERVER** on the file and overwrite it with the SSAS Datasource address to be used. It is also possible to add or edit the Datasources later on via web ui using an admin user.
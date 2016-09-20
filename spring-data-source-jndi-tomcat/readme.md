spring-data-source-jndi-tomcat
--------------------------------
@Ref: http://www.journaldev.com/2597/spring-datasource-jndi-with-tomcat-example


Spring DataSource
-------------------
We know that DataSource with JNDI is the preferred way to achieve connection pooling and get benefits of container implementations. Today we will look how we can configure a Spring Web Application to use JNDI connections provided by Tomcat.

For my example, I will use MySQL database server and create a simple table with some rows. We will create a Spring Rest web service that will return the JSON response with list of all the data in the table.


Important Points about the Controller class are:
-----------------------------------------
1. DataSource will be wired by Spring Bean configuration with name dbDataSource.
2. We are using JdbcTemplate to avoid common errors such as resource leak and remove JDBC boiler plate code.
3. URI to retrieve the list of Employee will be http://{host}:{port}/SpringDataSource/rest/emps
4. We are using @ResponseBody to send the list of Employee objects as response, Spring will take care of converting it to JSON.


Spring Bean Configuration
----------------------------
There are two ways through which we can JNDI lookup and wire it to the Controller DataSource, my spring bean configuration file contains both of them but one of them is commented. You can switch between these and the response will be the same.

1. Using jee namespace tag to perform the JNDI lookup and configure it as a Spring Bean. We also need to include jee namespace and schema definition in this case.
2. Creating a bean of type org.springframework.jndi.JndiObjectFactoryBean by passing the JNDI context name. jndiName is a required parameter for this configuration.

My spring bean configuration file looks like below.
------------------

<?xml version="1.0" encoding="UTF-8"?>
<beans:beans xmlns="http://www.springframework.org/schema/mvc"
	xmlns:jee="http://www.springframework.org/schema/jee"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:context="http://www.springframework.org/schema/context"
	xmlns:beans="http://www.springframework.org/schema/beans"
	xsi:schemaLocation="http://www.springframework.org/schema/jee http://www.springframework.org/schema/jee/spring-jee.xsd
		http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc.xsd
		http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context.xsd
		http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans.xsd">

	<!-- DispatcherServlet Context: defines this servlet's request-processing infrastructure -->
	<!-- Enables the Spring MVC @Controller programming model -->
	<annotation-driven />

	<context:component-scan base-package="com.journaldev.spring.jdbc.controller" />

	<resources mapping="/resources/**" location="/resources/" />

	<beans:bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
		<beans:property name="prefix" value="/WEB-INF/views/" />
		<beans:property name="suffix" value=".jsp" />
	</beans:bean>

	<!-- Configure to plugin JSON as request and response in method handler -->
	<beans:bean class="org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter">
		<beans:property name="messageConverters">
			<beans:list>
				<beans:ref bean="jsonMessageConverter" />
			</beans:list>
		</beans:property>
	</beans:bean>

	<!-- Configure bean to convert JSON to POJO and vice versa -->
	<beans:bean id="jsonMessageConverter" class="org.springframework.http.converter.json.MappingJackson2HttpMessageConverter" />
	
	 
	<beans:bean id="dbDataSource" class="org.springframework.jndi.JndiObjectFactoryBean">
    	<beans:property name="jndiName" value="java:comp/env/jdbc/TestDB"/>
	</beans:bean>
</beans:beans>


Tomcat DataSource JNDI Configuration
------------------------------------------
Now that we are done with our project, the final part is to do the JNDI configuration in Tomcat container to create the JNDI resource.

Add below configuration in the GlobalNamingResources section of the server.xml file og tomcat.

<Resource name="jdbc/TestDB" 
      global="jdbc/TestDB" 
      auth="Container" 
      type="javax.sql.DataSource" 
      driverClassName="com.mysql.jdbc.Driver" 
      url="jdbc:mysql://localhost:3306/TestDB" 
      username="pankaj" 
      password="pankaj123" 
      maxActive="100" 
      maxIdle="20" 
      minIdle="5" 
      maxWait="10000"/>
      


We also need to create the Resource Link to use the JNDI configuration in our application, best way to add it in the server context.xml file of tomcat.

<ResourceLink name="jdbc/MyLocalDB"
                	global="jdbc/TestDB"
                    auth="Container"
                    type="javax.sql.DataSource" />


Notice that ResourceLink name should be matching with the JNDI context name we are using in our application. Also make sure MySQL jar is present in the tomcat lib directory, otherwise tomcat will not be able to create the MySQL database connection pool.

Running the Spring DataSource JNDI Sample Project

Our project and server configuration is done and we are ready to test it. Export the project as WAR file and place it in the tomcat deployment directory.

http://localhost:8080/SpringDataSource/rest/emps

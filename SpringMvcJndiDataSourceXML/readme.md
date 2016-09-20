SpringMvcJndiDataSourceXML
------------
@Ref: http://www.codejava.net/frameworks/spring/configuring-spring-mvc-jdbctemplate-with-jndi-data-source-in-tomcat


Configuring JNDI Data Source in Tomcat:
---------------------------------------
To create a JNDI data source configuration in Tomcat, add a <Resource>entry to the context.xml file under Tomcat’s conf directory as follows:

```
<Resource
    name="jdbc/UsersDB"
    auth="Container"
    type="javax.sql.DataSource"
    maxActive="100"
    maxIdle="30"
    maxWait="10000"
    driverClassName="com.mysql.jdbc.Driver"
    url="jdbc:mysql://localhost:3306/usersDB"
    username="root"
    password="secret"
    />
```
    
NOTES:
-----
Change the username and password according to yours.
The attribute name=”jdbc/UsersDB” will be looked up by the Spring MVC application.
For details about JNDI data source configuration in Tomcat, see the tutorial: Configuring JNDI DataSource for Database Connection Pooling in Tomcat

Referencing JNDI Data Source in Spring MVC application
--------------------------------------------------------
Now, it’s time to see how to look up a JNDI Data Source in our Spring MVC application. For your convenience, we describe the lookup mechanism for both configuration approaches:

Using Java-based configuration:
----------------------------------
Write the following method in your Java-based configuration class:

```
@Bean
public UserDAO getUserDao() throws NamingException {
    JndiTemplate jndiTemplate = new JndiTemplate();
    DataSource dataSource = (DataSource) jndiTemplate.lookup("java:comp/env/jdbc/UsersDB");
    return new UserDAOImpl(dataSource);
}
```

In this approach, a JndiTemplate is used to look up the JNDI data source specified by the given name. The prefix java:comp/env/ is required for looking up a JNDI name.


Using XML configuration:
--------------------------
Add the following beans declaration into your Spring context configuration file:

```
<bean id="dataSource" class="org.springframework.jndi.JndiObjectFactoryBean">
    <property name="jndiName" value="java:comp/env/jdbc/UsersDB"/>
</bean>
 
<bean id="userDao" class="net.codejava.spring.dao.UserDAOImpl">
    <constructor-arg>
        <ref bean="dataSource" />
    </constructor-arg>
</bean>
```

In this approach, a JndiObjectFactoryBean is declared and its attribute jndiName is set to the JNDI name of the data source. This FactoryBean returns a DataSource object which is injected into the userDao bean.

How to run the code?
----------------------
```
http://localhost:8080/SpringMvcJndiDataSourceXML/
```
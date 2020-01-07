<@nav0 activeCheck="${n0_intro!''}" url="/docs/intro" title="Introduction">
  <ul>
    <@nav1 activeCheck="${n1_firstentity!''}" url="/docs/intro/first-entity" title="First entity">
      <ul>
        <@smallnav activeCheck="${model!''}" url="/docs/intro/first-entity/model" title="Model"/>
        <@smallnav activeCheck="${mappedsuper!''}" url="/docs/intro/first-entity/mapped-superclass" title="MappedSuperclass"/>
        <@smallnav activeCheck="${constructors!''}" url="/docs/intro/first-entity/constructors" title="Constructors"/>
      </ul>
    </@nav1>
    <@nav1 activeCheck="${n1_queries!''}" url="/docs/intro/queries" title="Queries">
      <ul>
        <@smallnav activeCheck="${ormQuery!''}" url="/docs/intro/queries/orm-query" title="ORM query"/>
        <@smallnav activeCheck="${dtoQuery!''}" url="/docs/intro/queries/dto-query" title="DTO query"/>
        <@smallnav activeCheck="${sqlQuery!''}" url="/docs/intro/queries/sql-query" title="SQL query"/>
        <@smallnav activeCheck="${jdbcQuery!''}" url="/docs/intro/queries/jdbc-query" title="JDBC query"/>
      </ul>
    </@nav1>
    <@nav1 activeCheck="${n1_api!''}" url="/docs/intro/api" title="Database & DB"/>
    <@nav1 activeCheck="${n1_logging!''}" url="/docs/intro/logging" title="Logging"/>
    <@nav1 activeCheck="${n1_dbMigrations!''}" url="/docs/intro/db-migrations" title="DB Migrations"/>
    <@nav1 activeCheck="${n1_limitations!''}" url="/docs/intro/limitations" title="Limitations"/>
  </ul>
</@nav0>

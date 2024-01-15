<ul class="nav">
  <@nav1 activeCheck="${n2_types!''}" url="/docs/mapping/type" title="Types">
    <ul class="nav">
      <@smallnav activeCheck="${enum!''}" url="/docs/mapping/type/enum" title="Enum"/>
      <@smallnav activeCheck="${uuid!''}" url="/docs/mapping/type/uuid" title="UUID"/>
      <@smallnav activeCheck="${file!''}" url="/docs/mapping/type/file" title="File"/>
      <@smallnav activeCheck="${boolean!''}" url="/docs/mapping/type/boolean" title="Boolean"/>
      <@smallnav activeCheck="${time!''}" url="/docs/mapping/type/time" title="Date and Time"/>
      <@smallnav activeCheck="${numeric!''}" url="/docs/mapping/type/numeric" title="Numeric"/>
      <@smallnav activeCheck="${other!''}" url="/docs/mapping/type#other" title="Other"/>
    </ul>
  </@nav1>

  <@nav1 activeCheck="${n2_jpa!''}" url="/docs/mapping/jpa" title="JPA">
    <ul class="nav">
      <@smallnav activeCheck="${id!''}" url="/docs/mapping/jpa/id" title="@Id">
        <ul class="nav">
          <li><a href="#generated-value">Generated value</a></li>
          <li><a href="#identity">Identity</a></li>
          <li><a href="#uuid">UUID</a></li>
          <li><a href="#string">String</a></li>
          <li><a href="#no-id">No Id property</a></li>
          <li><a href="#custom">Custom Id Generator</a></li>
        </ul>
      </@smallnav>
      <@smallnav activeCheck="${version!''}" url="/docs/mapping/jpa/version" title="@Version"/>
      <@smallnav activeCheck="${mappedSuperclass!''}" url="/docs/mapping/jpa/mapped-superclass" title="@MappedSuperclass"/>
      <@smallnav activeCheck="${oneToMany!''}" url="/docs/mapping/jpa/one-to-many" title="@OneToMany">
        <ul class="nav">
          <li><a href="#pair">Relationship pair</a></li>
          <li><a href="#mappedBy">mappedBy</a></li>
          <li><a href="#bidirectional">Bi-directional</a></li>
          <li><a href="#no-OneToMany">Not mapping the @OneToMany</a></li>
          <li><a href="#no-ManyToOne">Not mapping the @ManyToOne</a></li>
        </ul>
      </@smallnav>
      <@smallnav activeCheck="${manyToOne!''}" url="/docs/mapping/jpa/many-to-one" title="@ManyToOne">
        <ul class="nav">
          <li><a href="#pair">Relationship pair</a></li>
          <li><a href="#optional">Optional false</a></li>
          <li><a href="#notNull">@NotNull</a></li>
        </ul>
      </@smallnav>
      <@smallnav activeCheck="${oneToOne!''}" url="/docs/mapping/jpa/one-to-one" title="@OneToOne">
        <ul class="nav">
          <li><a href="#pair">Relationship pair</a></li>
          <li><a href="#manySide">@OneToOne "many" side</a></li>
          <li><a href="#oneSide">@OneToOne "one" side</a></li>
        </ul>
      </@smallnav>
      <@smallnav activeCheck="${manyToMany!''}" url="/docs/mapping/jpa/many-to-many" title="@ManyToMany">
        <ul class="nav">
          <li><a href="#enhancement">Enhancement</a></li>
        </ul>
      </@smallnav>
      <@smallnav activeCheck="${lob!''}" url="/docs/mapping/jpa/lob" title="@Lob"/>
    </ul>
  </@nav1>

  <@nav1 activeCheck="${n2_extn!''}" url="/docs/mapping/extensions" title="Extensions">
    <ul class="nav">
      <@smallnav activeCheck="${Identity!''}" url="/docs/mapping/extensions/identity" title="@Identity"></@smallnav>
      <@smallnav activeCheck="${DbIndex!''}" url="/docs/mapping/extensions/dbindex" title="@Index"></@smallnav>
      <@smallnav activeCheck="${DbEnumValue!''}" url="/docs/mapping/extensions/dbenumvalue" title="@DbEnumValue"></@smallnav>
      <@smallnav activeCheck="${DbJson!''}" url="/docs/mapping/extensions/dbjson" title="@DbJson">
        <ul class="nav">
          <li><a href="#overview">Overview</a></li>
          <li><a href="#mixed">Mixing structured and unstructured</a></li>
          <li><a href="#simple-types">Mapping simple types</a></li>
          <li><a href="#jackson">Mapping with Jackson ObjectMapper</a></li>
          <li><a href="#fallback">Fallback mapping</a></li>
          <li><a href="#expressions">Query expressions</a></li>
        </ul>
      </@smallnav>
      <@smallnav activeCheck="${DbArray!''}" url="/docs/mapping/extensions/dbarray" title="@DbArray"></@smallnav>
      <@smallnav activeCheck="${DbMap!''}" url="/docs/mapping/extensions/dbmap" title="@DbMap"></@smallnav>
      <@smallnav activeCheck="${DbForeignKey!''}" url="/docs/mapping/extensions/dbforeignkey" title="@DbForeignKey"></@smallnav>
      <@smallnav activeCheck="${DbComment!''}" url="/docs/mapping/extensions/dbcomment" title="@DbComment"></@smallnav>
      <@smallnav activeCheck="${DbPartition!''}" url="/docs/mapping/extensions/dbpartition" title="@DbPartition"/>
      <@smallnav activeCheck="${WhenCreated!''}" url="/docs/mapping/extensions/when-created" title="@WhenCreated"/>
      <@smallnav activeCheck="${WhenModified!''}" url="/docs/mapping/extensions/when-modified" title="@WhenModified"/>
      <@smallnav activeCheck="${WhoCreated!''}" url="/docs/mapping/extensions/who-created" title="@WhoCreated"/>
      <@smallnav activeCheck="${WhoModified!''}" url="/docs/mapping/extensions/who-modified" title="@WhoModified"/>
      <@smallnav activeCheck="${SoftDelete!''}" url="/docs/mapping/extensions/soft-delete" title="@SoftDelete"/>
      <@smallnav activeCheck="${Encrypted!''}" url="/docs/mapping/extensions/encrypted" title="@Encrypted"/>
      <@smallnav activeCheck="${Formula!''}" url="/docs/mapping/extensions/formula" title="@Formula"/>
      <@smallnav activeCheck="${View!''}" url="/docs/mapping/extensions/view" title="@View"/>
      <@smallnav activeCheck="${History!''}" url="/docs/mapping/extensions/history" title="@History"/>
      <@smallnav activeCheck="${ChangeLog!''}" url="/docs/mapping/extensions/change-log" title="@ChangeLog"/>
      <@smallnav activeCheck="${ReadAudit!''}" url="/docs/mapping/extensions/read-audit" title="@ReadAudit"/>
    </ul>
  </@nav1>
</ul>

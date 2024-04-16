
import io.ebean.Model
import io.ebean.annotation.WhenCreated
import io.ebean.annotation.WhenModified
import java.time.Instant
import jakarata.persistence.Id
import jakarata.persistence.MappedSuperclass
import jakarata.persistence.Version

@MappedSuperclass
open class BaseModel : Model() {

  @Id
  var id: Long = 0

  @Version
  var version: Long = 0

  @WhenCreated
  lateinit var whenCreated: Instant

  @WhenModified
  lateinit var whenModified: Instant
}

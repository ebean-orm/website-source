
import io.ebean.annotation.Length
import javax.persistence.Entity

@Entity
class Customer(name: String) : BaseModel() {

  @Length(120)
  var name: String = name

}


import io.ebean.annotation.NotNull;

import javax.persistence.Entity;
import javax.persistence.Table;
import java.time.LocalDate;

/**
 * Customer entity bean.
 */
@Entity
@Table(name = "customer")
public class Customer extends BaseModel {

  @NotNull
  private String name;

  private LocalDate registered;

  public Customer(String name) {
    this.name = name;
  }

  public String toString() {
    return "id:" + id + " name:" + name;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public LocalDate getRegistered() {
    return registered;
  }

  public void setRegistered(LocalDate registered) {
    this.registered = registered;
  }
}

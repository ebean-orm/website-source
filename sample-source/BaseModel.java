
import io.ebean.Model;
import io.ebean.annotation.WhenCreated;
import io.ebean.annotation.WhenModified;

import jakarata.persistence.Id;
import jakarata.persistence.MappedSuperclass;
import jakarata.persistence.Version;
import java.time.Instant;

/**
 * Base domain object with Id, version, whenCreated and whenModified.
 */
@MappedSuperclass
public abstract class BaseModel extends Model {

  @Id
  protected long id;

  @Version
  protected Long version;

  @WhenCreated
  protected Instant whenCreated;

  @WhenModified
  protected Instant whenModified;

  public long getId() {
    return id;
  }

  public void setId(long id) {
    this.id = id;
  }

  public Long getVersion() {
    return version;
  }

  public void setVersion(Long version) {
    this.version = version;
  }

  public Instant getWhenCreated() {
    return whenCreated;
  }

  public void setWhenCreated(Instant whenCreated) {
    this.whenCreated = whenCreated;
  }

  public Instant getWhenModified() {
    return whenModified;
  }

  public void setWhenModified(Instant whenModified) {
    this.whenModified = whenModified;
  }

}

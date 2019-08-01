
import io.ebean.DB;
import org.example.domain.query.QCustomer;
import org.junit.Test;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;

public class CustomerTest {


  @Test
  public void insertFindDelete() {

    Customer customer = new Customer("Rob");
    customer.save();

    // find using a query bean
    final Customer rob = new QCustomer()
      .name.istartsWith("ro")
      .findOne();

    assertNotNull(rob);
    //assertThat(rob.id).isGreaterThan(0)

    // find using an expression query
    final Customer rob2 =
      DB.find(Customer.class)
        .where().istartsWith("name", "ro")
        .findOne();

    assertNotNull(rob2);

    rob.delete();

    final Customer notThere = DB.find(Customer.class, customer.getId());
    assertNull(notThere);
  }

}

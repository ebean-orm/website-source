
import io.ebean.DB;
import org.junit.Test;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;

public class CustomerTest {


  @Test
  public void insertFindDelete() {

    Customer customer = new Customer("Rob");
    customer.save();

    // find using an expression query
    final Customer rob =
      DB.find(Customer.class)
        .where().istartsWith("name", "ro")
        .findOne();

    assertNotNull(rob);

    // IDE Re-build to generate the QCustomer query bean
//    // find using a query bean
//    final Customer rob2 = new QCustomer()
//      .name.istartsWith("ro")
//      .findOne();
//
//    assertNotNull(rob);

    rob.delete();

    final Customer notThere = DB.find(Customer.class, customer.getId());
    assertNull(notThere);
  }

}

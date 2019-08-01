
import io.ebean.DB
import org.example.domain.query.QCustomer
import org.junit.Assert.*
import org.junit.Test


class CustomerTest {

  @Test
  fun `insert find delete`() {

    val customer = Customer("Rob")
    customer.save()

    //assertThat(customer.id).isGreaterThan(0)

    // find using a query bean
    val customers =
      QCustomer()
        .name.startsWith("Rob")
        .findList()

    //assertThat(customers).hasSize(1)

    // find using an expression query
    val rob2 = DB.find(Customer::class.java)
      .where().istartsWith("name", "ro")
      .findOne()

    assertNotNull(rob2)

    rob2?.delete()

    val exists = QCustomer()
      .setId(customer.id)
      .exists()

    assertFalse(exists)
  }
}

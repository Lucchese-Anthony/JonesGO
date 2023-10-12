package enigmatic.juggernauts.adv.innov3.jonesgo.repository;
import enigmatic.juggernauts.adv.innov3.jonesgo.Entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    @Query(nativeQuery = true, value = " SELECT user_id, username, ejnumber" +
            " FROM T_Users" +
            " WHERE ejnumber = :pnumber")
    User findByPNumber (@Param("pnumber") String pNumber);
}

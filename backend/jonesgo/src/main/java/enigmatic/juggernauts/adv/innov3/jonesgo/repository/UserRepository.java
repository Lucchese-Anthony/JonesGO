package enigmatic.juggernauts.adv.innov3.jonesgo.repository;
import enigmatic.juggernauts.adv.innov3.jonesgo.Entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

}

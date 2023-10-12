package enigmatic.juggernauts.adv.innov3.jonesgo.repository;

import enigmatic.juggernauts.adv.innov3.jonesgo.Entity.Points;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PointsRepository extends JpaRepository<Points, Integer> {
    List<Points> findByPorJ(String id);

}

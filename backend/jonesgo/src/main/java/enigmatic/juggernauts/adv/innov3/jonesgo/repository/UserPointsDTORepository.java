package enigmatic.juggernauts.adv.innov3.jonesgo.repository;

import enigmatic.juggernauts.adv.innov3.jonesgo.Entity.UserPointsDTO;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;

import java.util.List;

public interface UserPointsDTORepository extends JpaRepository<UserPointsDTO, Integer> {
    @Procedure (value = "GET_LEADERBOARDS")
    List<UserPointsDTO> getLeaderboards();

}

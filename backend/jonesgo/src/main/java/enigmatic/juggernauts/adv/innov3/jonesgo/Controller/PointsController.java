package enigmatic.juggernauts.adv.innov3.jonesgo.Controller;

import enigmatic.juggernauts.adv.innov3.jonesgo.Entity.Points;
import enigmatic.juggernauts.adv.innov3.jonesgo.repository.PointsRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class PointsController {

    UserController userController = new UserController();
    @Autowired
    private PointsRepository pointsRepository;

    @GetMapping("/points")
    public List<Points> getPoints() {
        return pointsRepository.findAll();
    }

    @GetMapping("/points/id/{id}")
    public Points getPoint(int id) {
        return pointsRepository.findById(1).get();
    }

//    @GetMapping("/points/porj/{pOrj}")
//    public int getPoints(String pOrj) {
//        return pointsRepository.findById(userController.getUserFromEjNumber(pOrj).getUser_id()).get().getPoints();
//    }

    // @GetMapping("/leaderboard")
    // use the GET_LEADERBOARDS routine in the database
    //

    @PostMapping("/points")
    public Points createPoint(Points points) {
        return pointsRepository.save(points);
    }



}

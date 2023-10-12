package enigmatic.juggernauts.adv.innov3.jonesgo.Controller;

import enigmatic.juggernauts.adv.innov3.jonesgo.Entity.User;
import enigmatic.juggernauts.adv.innov3.jonesgo.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class UserController {
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/users")
    public List<User> getUsers() {
        List<User> users = userRepository.findAll();
        System.out.println(users);
        return userRepository.findAll();
    }

    @PostMapping("/users")
    public User createUser(@RequestBody User user) {
        return userRepository.save(user);
    }
    @GetMapping("/users/pORj/{porj}")
    public User getUserFromEjNumber(String porj) {
        return userRepository.findAll().stream().filter(user -> user.getPNumber().equals(porj)).findFirst().get();
    }

}

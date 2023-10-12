package enigmatic.juggernauts.adv.innov3.jonesgo.Controller;

import enigmatic.juggernauts.adv.innov3.jonesgo.Entity.User;
import enigmatic.juggernauts.adv.innov3.jonesgo.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@Slf4j
@Validated
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

    @GetMapping("/userById")
    public Optional<User> getUserById (@RequestParam(name = "id") int id){
        Optional<User> userById = userRepository.findById(id);
        return userById;
    }

    @GetMapping("/userByPNumber/{pNumber}")
    public User getUserByPNumber (@PathVariable(name = "pNumber") String pNumber){
        User userByPNumber = userRepository.findByPNumber(pNumber);
        return userByPNumber;
    }

}

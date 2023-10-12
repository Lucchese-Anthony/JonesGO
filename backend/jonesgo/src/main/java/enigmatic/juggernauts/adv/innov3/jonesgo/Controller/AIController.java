package enigmatic.juggernauts.adv.innov3.jonesgo.Controller;

import org.springframework.web.bind.annotation.GetMapping;

public class AIController {

    @GetMapping("/ai/{prompt}")
    public String getResponse(String prompt) {
        String API_TOKEN = "";
        String API_URL = "https://api.openai.com/v1/engines/davinci/completions";
        return "Hello World";
    }
}

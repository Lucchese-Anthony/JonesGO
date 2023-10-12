package enigmatic.juggernauts.adv.innov3.jonesgo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class JonesGoApplication {

	public static void main(String[] args) {
		SpringApplication.run(JonesGoApplication.class, args);
	}

}

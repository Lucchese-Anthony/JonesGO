package enigmatic.juggernauts.adv.innov3.jonesgo.Entity;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Builder
@Table(name = "T_POINTS")
public class Points {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "point_id")
    private int pointId;
    private int points;
    @Column(name = "Location")
    private String location;
    @Column(name = "Cooldown")
    private int cooldown;
    @Column(name = "Description")
    private String description;

}

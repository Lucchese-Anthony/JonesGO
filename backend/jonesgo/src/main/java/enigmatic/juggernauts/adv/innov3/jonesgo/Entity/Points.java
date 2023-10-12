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
    @Column(name = "points")
    private int points;
    @Column(name = "latitude")
    private String latitude;
    @Column(name="longitude")
    private String longitude;
    @Column(name = "cooldown")
    private int cooldown;
    @Column(name = "description")
    private String description;


}

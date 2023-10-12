package enigmatic.juggernauts.adv.innov3.jonesgo.Entity;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Builder
@Table(name = "TA_Users_Points")
public class UserPointsDTO {

        // set userID and pointID as foreign keys to the User and Points tables
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "point_user_id")
        private int userPointId;
        @Column(name = "user_id")
        private int userId;
        @Column(name = "point_id")
        private int pointId;


}

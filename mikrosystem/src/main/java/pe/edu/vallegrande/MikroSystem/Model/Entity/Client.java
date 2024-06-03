package pe.edu.vallegrande.MikroSystem.Model.Entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "CLIENT")
public class Client {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ID")
    private Long id;

    @Column(name = "NAME")
    private String name;

    @Column(name = "LAST_NAME")
    private String last_name;

    @Column(name = "CELLPHONE")
    private String cellphone;

    @Column(name = "EMAIL")
    private String email;

    @Column(name = "TYPE_DOCUMENT")
    private String type_document;

    @Column(name = "DOCUMENT_NUMBER")
    private String document_number;

    @Column(name = "DISTRICT_ID")
    private Integer district_id;

    @Column(name = "ADDRESS")
    private String address;

    @Column(name = "STATE")
    private String state;

    @Column(name = "BIRTHDATE")
    @Temporal(TemporalType.DATE)
    private Date birthdate;

}

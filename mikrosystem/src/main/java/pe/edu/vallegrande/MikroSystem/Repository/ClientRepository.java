package pe.edu.vallegrande.MikroSystem.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import pe.edu.vallegrande.MikroSystem.Model.Entity.Client;

import java.util.List;

public interface ClientRepository extends JpaRepository<Client, Long> {

    List<Client> findByState(String state);

    @Modifying
    @Query(value = "update Client s set s.state = 'I' where s.id = ?1")
    void deactivateClient(Long id);

    @Modifying
    @Query(value = "update Client s set s.state = 'A' where s.id = ?1")
    void activateClient(Long id);

    @Modifying
    @Query(value = "delete from Client s where s.id = ?1")
    void deleteClient(Long id);
}

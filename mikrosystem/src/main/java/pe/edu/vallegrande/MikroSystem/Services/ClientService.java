package pe.edu.vallegrande.MikroSystem.Services;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.edu.vallegrande.MikroSystem.Model.Entity.Client;
import pe.edu.vallegrande.MikroSystem.Repository.ClientRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ClientService {

    private final ClientRepository clientRepository;
    public List<Client> findActiveClients() {
        return clientRepository.findByState("A");
    }
    public List<Client> findAll() {
        return clientRepository.findAll();
    }
    public List<Client> findDeactivateClients() {
        return clientRepository.findByState("I");
    }
    public Optional<Client> findById(Long id) {
        return clientRepository.findById(id);
    }
    @Transactional
    public Client save(Client client) {
        // Establecer el estado predeterminado como 'A' al guardar
        client.setState("A");
        return clientRepository.save(client);
    }
    @Transactional
    public Client update(Long id, Client client) {
        client.setId(id);
        return clientRepository.save(client);
    }
    @Transactional
    public Optional<Client> deactivate(Long id) {
        clientRepository.deactivateClient(id);
        return clientRepository.findById(id);
    }

    @Transactional
    public Optional<Client> activate(Long id) {
        clientRepository.activateClient(id);
        return clientRepository.findById(id);
    }

    @Transactional
    public void delete(Long id) {
        clientRepository.deleteClient(id);
    }
}

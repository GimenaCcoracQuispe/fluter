package pe.edu.vallegrande.MikroSystem.Controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.edu.vallegrande.MikroSystem.Model.Entity.Client;
import pe.edu.vallegrande.MikroSystem.Services.ClientService;

import java.util.List;
import java.util.Optional;

@RestController
@CrossOrigin(origins = "http://localhost:4200")
@RequiredArgsConstructor
@RequestMapping("/v1/clients")
public class ClientController {
    private final ClientService clientService;

    @GetMapping
    public ResponseEntity<List<Client>> findAll() {
        List<Client> books = clientService.findAll();
        return ResponseEntity.status(HttpStatus.OK).body(books);
    }

    @GetMapping("/activate")
    public ResponseEntity<List<Client>> findActiveStudents() {
        List<Client> activeClients = clientService.findActiveClients();
        return ResponseEntity.ok(activeClients);
    }

    @GetMapping("/deactivate")
    public ResponseEntity<List<Client>> findDeactivateStudents() {
        List<Client> deactivateClients = clientService.findDeactivateClients();
        return ResponseEntity.ok(deactivateClients);
    }

    @PostMapping
    public ResponseEntity<Client> save(@RequestBody Client client) {
        Client savedClient = clientService.save(client);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedClient);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Optional<Client>> findById(@PathVariable Long id) {
        Optional<Client> client = clientService.findById(id);
        if (client.isPresent()) {
            return ResponseEntity.status(HttpStatus.OK).body(client);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(client);
        }
    }

    /*@PutMapping("/{id}")
    public ResponseEntity<User> update(@PathVariable Long id, @RequestBody User updatedStudent) {
        Optional<User> existingStudentOptional = userService.findById(id);

        if (existingStudentOptional.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        User existingUser = existingStudentOptional.get();

        // Update fields
        if (updatedStudent.getNames() != null) {
            existingUser.setNames(updatedStudent.getNames());
        }

        if (updatedStudent.getLastName() != null) {
            existingUser.setLastName(updatedStudent.getLastName());
        }

        if (updatedStudent.getDocumentTypeId() != null) {
            existingUser.setDocumentTypeId(updatedStudent.getDocumentTypeId());
        }

        if (updatedStudent.getNumberDocument() != null) {
            existingUser.setNumberDocument(updatedStudent.getNumberDocument());
        }

        if (updatedStudent.getAcademicLevelId() != null) {
            existingUser.setAcademicLevelId(updatedStudent.getAcademicLevelId());
        }

        if (updatedStudent.getGradeId() != null) {
            existingUser.setGradeId(updatedStudent.getGradeId());
        }

        if (updatedStudent.getEmail() != null) {
            existingUser.setEmail(updatedStudent.getEmail());
        }

        if (updatedStudent.getPassword() != null) {
            existingUser.setPassword(updatedStudent.getPassword());
        }

        if (updatedStudent.getCellPhone() != null) {
            existingUser.setCellPhone(updatedStudent.getCellPhone());
        }

        if (updatedStudent.getState() != null) {
            existingUser.setState(updatedStudent.getState());
        }

        // Call the service to save the partial update
        User savedUser = userService.update(id, existingUser);

        return ResponseEntity.status(HttpStatus.OK).body(savedUser);
    }*/

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        clientService.delete(id);
        return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
    }

    @DeleteMapping("/deactivate/{id}")
    public ResponseEntity<Optional<Client>> deactivate(@PathVariable Long id) {
        Optional<Client> deactivatedClient = clientService.deactivate(id);
        if (deactivatedClient.isPresent()) {
            return ResponseEntity.status(HttpStatus.OK).body(deactivatedClient);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(deactivatedClient);
        }
    }

    @PutMapping("/activate/{id}")
    public ResponseEntity<Optional<Client>> activate(@PathVariable Long id) {
        Optional<Client> activatedClient = clientService.activate(id);
        if (activatedClient.isPresent()) {
            return ResponseEntity.status(HttpStatus.OK).body(activatedClient);
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(activatedClient);
        }
    }
}

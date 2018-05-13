package services;

import entities.User;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Repository;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.transaction.Transactional;
import java.util.List;

@Repository
public class UserService {

    @PersistenceContext
    private EntityManager em;

    public List<User> getAll() {
        return em
                .createNamedQuery("User.getAll", User.class)
                .getResultList();
    }

    public User getByUsername(String username) {
        return em
                .createNamedQuery("User.getByEmail", User.class)
                .setParameter("email", username)
                .getSingleResult();
    }

    public User exists(User u) {
        try {
            return getByUsername(u.getEmail());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public User login(User u) {
        User existingUser;
        if ((existingUser = exists(u)) != null
                && BCrypt.checkpw(u.getPassword(), existingUser.getPassword())) {
            return existingUser;
        }
        return null;
    }

    @Transactional
    public void register(User u) {
        u.setPassword(BCrypt.hashpw(u.getPassword(), BCrypt.gensalt(12)));
        em.persist(u);
    }
}
